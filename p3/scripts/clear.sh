#!/bin/bash

set -e

CLUSTER_NAME="my-cluster"

echo "--- Deleting K3d cluster: $CLUSTER_NAME... ---"
if k3d cluster get "$CLUSTER_NAME" &> /dev/null; then
    k3d cluster delete "$CLUSTER_NAME"
    echo "--- Cluster '$CLUSTER_NAME' deleted successfully. ---"
else
    echo "--- Cluster '$CLUSTER_NAME' not found. Skipping deletion. ---"
fi

echo ""
echo "--- Cleaning up Docker resources (unused containers, images, networks)... ---"
docker system prune -af
echo ""
echo "--- Environment has been cleared successfully! ---"