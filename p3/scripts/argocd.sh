#!/bin/bash

# Insatall Argo CD
echo "--- Installing Argo CD into 'argocd' namespace ---"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "--- Waiting for Argo CD server to be ready... ---"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Port forwarding to access Argo CD UI(새 터미널에서 실행)
echo "--- To access the Argo CD UI, run the following command in a new terminal: ---"
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"
# echo "--- Starting port-forwarding in the background... ---"
# kubectl port-forward svc/argocd-server -n argocd 8080:443 &


# getting default admin pw
ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "-------------------------------------------------"
echo "Argo CD UI available at: https://localhost:8080"
echo "Username: admin"
echo "Password: $ADMIN_PASSWORD"
echo "-------------------------------------------------"

kubectl port-forward svc/argocd-server -n argocd 8080:443 
