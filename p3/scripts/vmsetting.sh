#!/usr/bin/env bash
set -euo pipefail

VM="${VM_NAME:-p3}"
ISO_DIR="${ISO_DIR:-$HOME/goinfre}"
ISO="${ISO_PATH:-$HOME/goinfre/debian-13.1.0-amd64-netinst.iso}"

RAM_MB="${RAM_MB:-8192}"
CPUS="${CPUS:-4}"
DISK_GB="${DISK_GB:-30}"

# port forwarding
SSH_PORT="${SSH_PORT:-2222}"            # host 2222 -> guest 22
ARGO_PORT="${ARGO_PORT:-8080}"          # host 8080 -> guest 8080
APP_PORT="${APP_PORT:-8888}"            # host 8888 -> guest 8888
K8S_PORT="${K8S_API_PORT:-6443}"    # host 6443 -> guest 6443
GITLAB_PORT="${GITLAB_API_PORT:-8081}"


VDI="$HOME/goinfre/VirtualBoxVMs/$VM/$VM.vdi"

if [[ ! -f "$ISO" ]]; then
  echo "[STEP] ISO not found, downloading..."
  mkdir -p "$ISO_DIR"
  wget -O "$ISO" \
    "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"
else
  echo "[INFO] ISO already exists: $ISO"
fi

echo "[INFO] VM name: $VM"
echo "[INFO] ISO address: $ISO"
echo "[INFO] dick: $VDI"
echo "[INFO] memory: ${RAM_MB}MB, CPU: ${CPUS}, disk: ${DISK_GB}GB"
echo

# create vm
if ! VBoxManage showvminfo "$VM" >/dev/null 2>&1; then
  echo "[STEP] createvm"
  VBoxManage createvm --name "$VM" --register
else
  echo "[INFO] already exist: $VM"
fi

echo "[STEP] modifyvm (resouce/OS type)"
VBoxManage modifyvm "$VM" --memory "$RAM_MB" --cpus "$CPUS" --ostype "Debian_64"

echo "[STEP] Network (NAT + portforwarding)"
VBoxManage modifyvm "$VM" --nic1 nat

# initialize rules
for rule in ssh argo app k8sapi; do
  VBoxManage modifyvm "$VM" --natpf1 delete "$rule" 2>/dev/null || true
done

VBoxManage modifyvm "$VM" --natpf1 "ssh,tcp,127.0.0.1,${SSH_PORT},,22"
VBoxManage modifyvm "$VM" --natpf1 "argo,tcp,127.0.0.1,${ARGO_PORT},,8080"
VBoxManage modifyvm "$VM" --natpf1 "app,tcp,127.0.0.1,${APP_PORT},,8888"
VBoxManage modifyvm "$VM" --natpf1 "k8sapi,tcp,127.0.0.1,${K8S_PORT},,6443"
VBoxManage modifyvm "$VM" --natpf1 "gitlab,tcp,127.0.0.1,${GITLAB_PORT},,8081"

# storage controller
echo "[STEP] add storage controller"
if ! VBoxManage showvminfo "$VM" | grep -q '^Storage Controller Name.*SATA'; then
  VBoxManage storagectl "$VM" --name "SATA" --add sata --controller IntelAhci
fi

# create virtual disk
if [[ ! -f "$VDI" ]]; then
  echo "[STEP] virtual disk creation ${DISK_GB}GB"
  mkdir -p "$(dirname "$VDI")"
  VBoxManage createmedium disk --filename "$VDI" --size $(( DISK_GB * 1024 ))  # MB
fi

# iso - disk connection
VBoxManage storageattach "$VM" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "$VDI"
VBoxManage storageattach "$VM" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium "$ISO"

# boot dvd first
VBoxManage modifyvm "$VM" --boot1 dvd --boot2 disk

# boot vm
echo "[STEP] VM booting... "
VBoxManage startvm "$VM" --type gui

# reset ssh-key
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[127.0.0.1]:${SSH_PORT}" || true

cat <<EOF

[process left]
1) Keep install Debian 13 with GUI
   - check "OpenSSH server" installation option
   - set user id and pw

2) when installion done and reboot, run commend below to seperate ISO
  VBoxManage storageattach "$VM" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium none

3) ssh -p 2222 jischoi@127.0.0.1 "mkdir -p ~/p3"

3) scp -P 2222 -r confs Dockerfile scripts jischoi@127.0.0.1:/home/jischoi/p3/

4) SSH conection test on local(host):
   ssh -p ${SSH_PORT} <username>@127.0.0.1

5) to access with key:
   ssh-keygen -t ed25519
   ssh-copy-id -p ${SSH_PORT} <username>@127.0.0.1

6) run setup.sh
  sudo usermod -aG docker jischoi
  reboot
  run install.sh
  kubectl version --client
  k3d version
  run create_cluster.sh


EOF
