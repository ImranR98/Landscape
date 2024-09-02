#!/bin/bash -e

# Adapted from https://docs.fedoraproject.org/en-US/quick-docs/using-kubernetes/#sect-fedora40-and-newer
# And https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart

# sudo kubeadm --cri-socket unix:///var/run/crio/crio.sock reset # Delete existing cluster

NODE_TYPE="$1"
if [ "$NODE_TYPE" != 'master' ] && [ "$NODE_TYPE" != 'worker' ]; then
    echo "Node type not specified! Must be 'master' or 'worker'." >&2
    exit 1
fi

# Disable swap
sudo systemctl stop swap-create@zram0 || :
sudo dnf remove -y zram-generator-defaults
sudo swapoff -a

# Add firewall exceptions
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10255/tcp
sudo firewall-cmd --permanent --add-port=8472/udp
sudo firewall-cmd --permanent --add-port=30000-32767/tcp
sudo firewall-cmd --add-masquerade --permanent
sudo firewall-cmd --permanent --add-port=179/tcp
sudo firewall-cmd --permanent --add-port=4789/udp
sudo firewall-cmd --permanent --add-port=5473/tcp
sudo firewall-cmd --permanent --add-port=9099/tcp
sudo firewall-cmd --permanent --add-port=9099/udp
sudo firewall-cmd --permanent --zone=trusted --add-interface="cali+"
sudo firewall-cmd --permanent --zone=trusted --add-interface="tunl+"
sudo firewall-cmd --permanent --zone=trusted --add-interface="vxlan-v6.calico"
sudo firewall-cmd --permanent --zone=trusted --add-interface="vxlan.calico"
sudo firewall-cmd --permanent --zone=trusted --add-interface="wg-v6.cali"
sudo firewall-cmd --permanent --zone=trusted --add-interface="wireguard.cali"
if [ "$NODE_TYPE" = 'master' ]; then
    sudo firewall-cmd --permanent --add-port=6443/tcp
    sudo firewall-cmd --permanent --add-port=2379-2380/tcp
    sudo firewall-cmd --permanent --add-port=10250/tcp
    sudo firewall-cmd --permanent --add-port=10251/tcp
    sudo firewall-cmd --permanent --add-port=10252/tcp
    sudo firewall-cmd --permanent --add-port=10255/tcp
    sudo firewall-cmd --permanent --add-port=8472/udp
    sudo firewall-cmd --add-masquerade --permanent
    sudo firewall-cmd --permanent --add-port=30000-32767/tcp
    sudo firewall-cmd --permanent --add-port=10250/tcp
    sudo firewall-cmd --permanent --add-port=10255/tcp
    sudo firewall-cmd --permanent --add-port=8472/udp
    sudo firewall-cmd --permanent --add-port=30000-32767/tcp
    sudo firewall-cmd --add-masquerade --permanent
    sudo firewall-cmd --permanent --zone=public --add-service=http
    sudo firewall-cmd --permanent --zone=public --add-service=https
fi
sudo firewall-cmd --reload

# More networking changes
sudo dnf install -y iptables iproute-tc
sudo cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

# Install and enable K8s
sudo dnf install -y kubernetes kubernetes-kubeadm kubernetes-client cri-o containernetworking-plugins
sudo systemctl enable --now crio
sudo systemctl enable --now kubelet
sudo systemctl disable --now firewalld # TODO: How to avoid this?

# Setup the cluster
if [ "$NODE_TYPE" = 'master' ]; then
    # Init. cluster
    sudo kubeadm --cri-socket unix:///var/run/crio/crio.sock config images pull
    sudo kubeadm --cri-socket unix:///var/run/crio/crio.sock init --pod-network-cidr=10.244.0.0/16
    # Use user-specific config, leaving original unchanged
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    # Allow the master to also be a worker
    kubectl taint nodes --all node-role.kubernetes.io/control-plane-
    # Add overlay networking (Calico)
    (cat | sudo tee /etc/NetworkManager/conf.d/calico.conf) <<-EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*;interface-name:vxlan.calico;interface-name:vxlan-v6.calico;interface-name:wireguard.cali;interface-name:wg-v6.cali
EOF
    sudo systemctl restart NetworkManager
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
    TEMP_YAML="$(mktemp)"
    wget -qO- https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml | sed 's/192.168/10.244/g' >"$TEMP_YAML"
    kubectl apply -f "$TEMP_YAML"
    rm "$TEMP_YAML"
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml
    # Check that all basic K8s components are running
    sleep 10
    kubectl get pods --all-namespaces
    sudo dnf install -y helm
else
    echo "You still need to join the cluster manually."
fi
