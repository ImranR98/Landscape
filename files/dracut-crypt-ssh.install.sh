#!/bin/bash
set -e
HERE_F9AC="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

USERNAME="$1"
if [ -z "$USERNAME" ]; then exit 1; fi

if ! which rpm-ostree; then
    dnf copr enable uriesk/dracut-crypt-ssh -y
    dnf install dracut-crypt-ssh -y
    sed -i 's/^\(GRUB_CMDLINE_LINUX=".*\)"/\1 rd.neednet=1 ip=dhcp"/' /etc/default/grub
    grub2-mkconfig --output /etc/grub2.cfg
else
    wget -nv https://copr.fedorainfracloud.org/coprs/uriesk/dracut-crypt-ssh/repo/fedora-42/uriesk-dracut-crypt-ssh-fedora-42.repo -O /etc/yum.repos.d/dracut-crypt-ssh.repo
    rpm-ostree initramfs --enable || :
    rpm-ostree refresh-md
    rpm-ostree install --apply-live --assumeyes dracut-crypt-ssh
    rpm-ostree kargs --append "rd.neednet=1 ip=dhcp"
fi

sed -i '/^#[[:space:]]*install_items/s/^#[[:space:]]*//' /etc/dracut.conf.d/crypt-ssh.conf # Ensure cryptsetup is included
sed -i 's/"222"/"22"/g' /etc/dracut.conf.d/crypt-ssh.conf                                  # Change to port 22
umask 0077
mkdir -p /etc/dracut-crypt-ssh-keys
test -f /etc/dracut-crypt-ssh-keys/ssh_dracut_rsa_key || ssh-keygen -t rsa -m PEM -f /etc/dracut-crypt-ssh-keys/ssh_dracut_rsa_key -N ""
test -f /etc/dracut-crypt-ssh-keys/ssh_dracut_ecdsa_key || ssh-keygen -t ecdsa -m PEM -f /etc/dracut-crypt-ssh-keys/ssh_dracut_ecdsa_key -N ""
test -f /etc/dracut-crypt-ssh-keys/ssh_dracut_ed25519_key || ssh-keygen -t ed25519 -m PEM -f /etc/dracut-crypt-ssh-keys/ssh_dracut_ed25519_key -N ""
mkdir -p /etc/.ssh
if [ -f "/home/$USERNAME/.ssh/authorized_keys" ]; then cp "/home/$USERNAME/.ssh/authorized_keys" /etc/.ssh/; fi

if ! which rpm-ostree; then
    dracut --force
fi
