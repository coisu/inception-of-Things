#!/bin/bash
set -e

# --- Configuration ---
ARGO_APP_FILE="../confs/deploy.yaml"
NEW_REPO_URL="http://localhost:8081/root/buthor.git"

echo "--- Updating Argo CD application manifest ---"
echo "Old repoURL:"
grep "repoURL" "$ARGO_APP_FILE"

# replacing
sed -i.bak "s|repoURL:.*|repoURL: $NEW_REPO_URL|" "$ARGO_APP_FILE"

echo "New repoURL:"
grep "repoURL" "$ARGO_APP_FILE"

echo "--- Applying updated configuration to the cluster ---"
kubectl apply -f "$ARGO_APP_FILE"

echo "Argo CD is now pointing to local GitLab repository!"