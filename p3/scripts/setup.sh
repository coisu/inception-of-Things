#!/usr/bin/env bash
set -euo pipefail

echo "== [1/5] apt update/upgrade =="
sudo apt update -y
sudo apt upgrade -y

echo "== [2/5] tools =="
sudo apt install -y curl ca-certificates gnupg lsb-release vim git

echo "== [3/5] docker gpg key =="
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg \
  | sudo tee /etc/apt/keyrings/docker.asc >/dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "== [4/5] docker repo (with fallback) =="
CODENAME="$(lsb_release -cs)"
USE="$CODENAME"
if ! curl -fsSL "https://download.docker.com/linux/debian/dists/${CODENAME}/Release" >/dev/null 2>&1; then
  USE="bookworm"
fi
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${USE} stable" \
 | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt update -y

echo "== [5/5] install docker =="
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

TARGET_USER="${SUDO_USER:-$USER}"
getent group docker >/dev/null || sudo groupadd docker
if id -nG "$TARGET_USER" | grep -qw docker; then
  echo "   -> ${TARGET_USER} already in docker group"
else
  echo "   -> add ${TARGET_USER} to docker group"
  sudo usermod -aG docker "$TARGET_USER"
  echo "      (re-login or run 'newgrp docker')"
fi

echo "== done =="
docker --version || true
