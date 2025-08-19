#!/bin/bash

echo "--- Updating package list ---"
sudo apt-get update

echo "--- Installing Docker prerequisites ---"
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

echo "--- Adding Docker's official GPG key ---"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "--- Setting up the Docker repository ---"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "--- Installing Docker Engine ---"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker vagrant

echo "--- Docker installed successfully! ---"
echo "--- VM setup is complete. You can now run your project scripts. ---"