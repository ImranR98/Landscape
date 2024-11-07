#!/bin/bash
set -e

HERE_M3U8="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd;)"
source "$HERE_M3U8"/init_vars.sh

# Install FRPS
syncRemoteEnvFileIfUndefined "$PROXY_SSH_STRING" "$PROXY_HOME/frps/frps-tokens.txt" "$MAIN_NODE_HOSTNAME_LOWERCASE" "$(echo $RANDOM | sha512sum | awk '{print $1}')$(echo $RANDOM | sha512sum | awk '{print $1}')" "$HERE_M3U8"/files/frps-tokens.txt
generateComposeService frps 1000 > "$HERE_M3U8"/files/frps.service
scp "$HERE_M3U8"/files/.gitignore "$PROXY_SSH_STRING":~/frps/.gitignore
scp "$HERE_M3U8"/files/frps-tokens.txt "$PROXY_SSH_STRING":~/frps/frps-tokens.txt
scp "$HERE_M3U8"/files/frps.docker-compose.yaml "$PROXY_SSH_STRING":~/frps/frps.docker-compose.yaml
scp "$HERE_M3U8"/files/frps.service "$PROXY_SSH_STRING":~/frps/frps.service
scp "$HERE_M3U8"/files/frps.install.sh "$PROXY_SSH_STRING":~/frps/install.sh
scp "$HERE_M3U8"/files/openTCPPort.sh "$PROXY_SSH_STRING":~/frps/openTCPPort.sh
rm "$HERE_M3U8"/files/frps.service
rm "$HERE_M3U8"/files/frps-tokens.txt
ssh -A -t "$PROXY_SSH_STRING" bash -l <<-EOF
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
if [ -z "\$VERSION_CODENAME" ]; then
    VERSION_CODENAME="\$(cat /etc/lsb-release | grep CODENAME | awk -F= '{print \$2}')"
fi
echo \
    "deb [arch="\$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "\$VERSION_CODENAME")" stable" |
sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker \$USER
EOF
ssh -A -t "$PROXY_SSH_STRING" "bash '$PROXY_HOME/frps/install.sh'"