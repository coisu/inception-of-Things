#!/usr/bin/env bash
set -euo pipefail

VM="${VM_NAME:-p3}"
VDI="$HOME/goinfre/VirtualBoxVMs/$VM/$VM.vdi"

echo "[INFO] Removing VM: $VM"

if VBoxManage showvminfo "$VM" >/dev/null 2>&1; then
  echo "[STEP] Power off VM if running..."
  VBoxManage controlvm "$VM" poweroff 2>/dev/null || true
  sleep 2

  echo "[STEP] Unregister and delete VM..."
  VBoxManage unregistervm "$VM" --delete || true
else
  echo "[WARN] VM $VM does not exist."
fi

if [[ -f "$VDI" ]]; then
  echo "[STEP] Removing virtual disk: $VDI"
  rm -f "$VDI"
fi

echo "[INFO] VM $VM removed successfully."
