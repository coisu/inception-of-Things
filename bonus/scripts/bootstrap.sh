#!/bin/bash

echo "--- Updating package list ---"
sudo apt-get update

echo "--- [1/4] Installing Docker ---"
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker vagrant
echo "--- Docker installed successfully! ---"

echo "--- [2/4] Installing kubectl ---"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
echo "--- kubectl installed successfully! ---"

echo "--- [3/4] Installing k3d ---"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "--- k3d installed successfully! ---"

echo "--- [4/4] Installing Helm ---"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "--- Helm installed successfully! ---"

echo "--- VM setup is complete ---"