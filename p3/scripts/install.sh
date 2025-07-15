#!/bin/bash

mkdir -p ~/.local/bin

echo "--- Installing kubectl ---"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl ~/.local/bin/
echo "--- kubectl installed ---"

echo "--- Installing K3d ---"
curl -Lo k3d "https://github.com/k3d-io/k3d/releases/download/v5.6.3/k3d-linux-amd64"
chmod +x k3d
mv k3d ~/.local/bin/
echo "--- K3d installed ---"

echo "--- setting path for env ---"
if ! grep -q 'export PATH=$HOME/.local/bin:$PATH' ~/.bashrc; then
    echo '' >> ~/.bashrc
    echo '# Local binaries' >> ~/.bashrc
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
fi
echo "--- done! ---"

echo "run 'source ~/.bashrc'"