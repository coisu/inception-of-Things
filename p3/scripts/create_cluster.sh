#!/bin/bash

CLUSTER_NAME="my-cluster"

echo "--- Creating K3d cluster: $CLUSTER_NAME ---"
k3d cluster create $CLUSTER_NAME --api-port 6443 -p "8888:80@loadbalancer" --agents 1

echo "--- Waiting for cluster to be ready... ---"
sleep 15
kubectl wait --for=condition=Ready node --all --timeout=300s

# Create dev, argocd namespace [cite: 460]
echo "--- Creating namespaces: dev and argocd ---"
kubectl create namespace dev
kubectl create namespace argocd

echo "--- Cluster and namespaces are ready ---"
kubectl get ns