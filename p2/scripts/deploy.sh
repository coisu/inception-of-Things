#!/bin/bash

echo "--- Deploying Kubernetes applications ---"

kubectl apply -f /vagrant/confs/

echo "Waiting for deployments to be ready..."
sleep 15
kubectl get pods

echo "--- Application deployment finished ---"
