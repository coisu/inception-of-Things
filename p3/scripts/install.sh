#!/usr/bin/env bash
set -euo pipefail

# =======================================
# install.sh
# Installs kubectl and k3d on a Linux system (Ubuntu/Debian recommended)
#
# Usage:
#   chmod +x install.sh
#   ./install.sh
#
# Make sure Docker is installed before running this script.
# =======================================

echo "== [1/2] Installing kubectl =="

# Download the latest stable version of kubectl
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
echo "Downloading kubectl version: ${KUBECTL_VERSION}"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

# Install kubectl to /usr/local/bin
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# Verify installation
if command -v kubectl >/dev/null 2>&1; then
  echo "kubectl installed successfully."
  kubectl version --client --output=yaml || true
else
  echo "Failed to install kubectl." >&2
  exit 1
fi

echo "== [2/2] Installing k3d =="

# Install k3d via official script
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Verify installation
if command -v k3d >/dev/null 2>&1; then
  echo "k3d installed successfully."
  k3d version || true
else
  echo "Failed to install k3d." >&2
  exit 1
fi

echo "== Installation complete =="
echo "You can now create a k3d cluster using, for example:"
echo "  k3d cluster create my-cluster --api-port 6443 -p \"8888:80@loadbalancer\" --agents 1"
