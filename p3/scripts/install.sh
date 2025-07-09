#!/bin/bash

# --- Docker 확인 ---
if ! command -v docker &> /dev/null || ! docker ps &> /dev/null
then
    echo "[ERROR] Docker가 설치되어 있지 않거나 실행할 권한이 없습니다."
    echo "이 스크립트를 계속하기 전에 Docker 문제를 먼저 해결해야 합니다."
    exit 1
else
    echo "[OK] Docker가 준비되었습니다."
fi

# --- kubectl 설치 (사용자 홈 디렉터리에) ---
if ! command -v kubectl &> /dev/null
then
    echo "--- kubectl 설치 시작 ---"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    # 사용자 개인 bin 폴더에 설치 (sudo 불필요)
    mkdir -p ~/.local/bin
    mv ./kubectl ~/.local/bin/kubectl
    # PATH에 추가되도록 .bashrc에 기록
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo "kubectl 설치 완료. 터미널을 재시작하여 PATH를 적용하세요."
else
    echo "kubectl이 이미 설치되어 있습니다."
fi

# --- k3d 설치 (sudo 불필요) ---
if ! command -v k3d &> /dev/null
then
    echo "--- k3d 설치 시작 ---"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    echo "k3d 설치 완료."
else
    echo "k3d가 이미 설치되어 있습니다."
fi