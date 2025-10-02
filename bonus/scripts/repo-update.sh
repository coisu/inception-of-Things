#!/bin/bash
set -euo pipefail

# --- Configuration ---
APP_FILE="../confs/application.yaml"
PROJ_FILE="../confs/project.yaml"
NEW_REPO_URL="http://localhost:8081/root/bonus-app.git"

echo "--- Updating Argo CD manifests ---"
echo "Old repoURL:"
grep "repoURL" "$APP_FILE"

# Replace only in application.yaml
sed -i.bak "s|repoURL:.*|repoURL: $NEW_REPO_URL|" "$APP_FILE"

echo "New repoURL:"
grep "repoURL" "$APP_FILE"

echo "--- Applying updated configuration to the cluster ---"
kubectl apply -f "$PROJ_FILE"
kubectl apply -f "$APP_FILE"

echo "Argo CD is now pointing to local GitLab repository!"
echo
echo "If GitLab port-forward is not running, start it with:"

