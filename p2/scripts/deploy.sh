#!/bin/bash

echo "--- Deploying Kubernetes applications ---"

kubectl apply -f /vagrant/confs/

echo "Waiting for deployments to be ready..."
sleep 30
kubectl get pods

echo "--- Application deployment finished ---"
