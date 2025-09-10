#!/bin/bash

CLUSTER_NAME="my-cluster"


echo "--- Creating K3d cluster: $CLUSTER_NAME ---"
k3d cluster create $CLUSTER_NAME --api-port 6443 -p "8888:80@loadbalancer" --agents 1

echo "--- Waiting for cluster to be ready... ---"
sleep 15
kubectl wait --for=condition=Ready node --all --timeout=300s

# Create dev, argocd namespace [cite: 460]
echo "--- Creating namespaces: dev and argocd ---"
kubectl get ns dev    >/dev/null 2>&1 || kubectl create ns dev
kubectl get ns argocd >/dev/null 2>&1 || kubectl create ns argocd

echo "--- Cluster and namespaces are ready ---"
kubectl get nodes
kubectl get ns

echo "Cluster '$CLUSTER_NAME' is ready. Host http://localhost:8888 will reach Service port 80."