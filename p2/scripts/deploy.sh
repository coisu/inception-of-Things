#!/bin/bash

echo "--- Deploying Kubernetes applications ---"

kubectl apply -f /vagrant/confs/

# echo "Waiting for deployments to be ready..."
# sleep 15

echo "Waiting for all deployments to be ready..."
kubectl rollout status deployment/app-one
kubectl rollout status deployment/app-two
kubectl rollout status deployment/app-three

echo "--- All deployments are ready ---"
kubectl get pods

echo "--- Application deployment finished ---"
