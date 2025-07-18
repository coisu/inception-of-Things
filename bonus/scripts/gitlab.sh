#!/bin/bash
set -e

# 색상 설정
GREEN="\033[32m"
RESET="\033[0m"

# GitLab 네임스페이스 생성
kubectl create namespace gitlab || true

# Helm 설치 (이미 설치되어 있으면 생략됨)
if ! command -v helm &> /dev/null; then
  echo "Helm not found. Installing..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# hosts 등록
HOST_ENTRY="127.0.0.1 gitlab.k3d.gitlab.com"
if ! grep -q "$HOST_ENTRY" /etc/hosts; then
  echo "$HOST_ENTRY" | sudo tee -a /etc/hosts
fi

# GitLab 설치
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=k3d.gitlab.com \
  --set global.hosts.externalIP=0.0.0.0 \
  --set global.hosts.https=false \
  --timeout 600s

# Web Pod가 뜰 때까지 대기
kubectl wait --for=condition=ready --timeout=1200s pod -l app=webservice -n gitlab

# GitLab 비밀번호 출력
echo -e "${GREEN}GitLab root password:"
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode
echo -e "${RESET}"

# 포트포워딩 실행 (백그라운드)
kubectl port-forward svc/gitlab-webservice-default -n gitlab 8081:8080 >/dev/null 2>&1 &
