#!/bin/bash
set -e

GREEN="\033[32m"
RESET="\033[0m"

kubectl create namespace gitlab || true

# install Helm
if ! command -v helm &> /dev/null; then
  echo "Helm not found. Installing..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

helm repo add gitlab https://charts.gitlab.io || true
helm repo update

# install GitLab
helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=localhost \
  --set global.hosts.externalIP=127.0.0.1 \
  --set global.hosts.https=false \
  --set global.ingress.enabled=false \
  --set gitlab.webservice.service.type=NodePort \
  --set gitlab.webservice.service.externalPort=32077 \
  --timeout 900s

# waiting Pod to be ready
# kubectl wait --for=condition=ready --timeout=1200s pod -l app=webservice -n gitlab

# GitLab pw
echo -e "${GREEN}GitLab root password:"
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode
echo -e "${RESET}"

cat <<EOF
check if every pods are running   kubectl get pods -n gitlab

kubectl get svc -n gitlab

when it's ready to port forwarding    kubectl port-forward svc/gitlab-webservice-default -n gitlab 8081:8181 --address 0.0.0.0
Forwarding from 0.0.0.0:8081 -> 8181
go to   http://localhost:8081 and create a new public project, check if the branch is protected

git init -b main
git remote add origin http://localhost:8081/root/{project-name}.git
git config user.name "root"
git config user.email "email..."
add / commit
git push -u origin main

when it went to wrong url:
git remote set-url origin {correct url}
git ls-remote http://localhost:8081/root/bonus-app.git



check deployment...
  kubectl get pods -n dev
  kubectl get svc -n dev
  kubectl get ingress -n dev



EOF
