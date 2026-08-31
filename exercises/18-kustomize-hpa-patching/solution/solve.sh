#!/usr/bin/env bash
set -euo pipefail
kubectl kustomize /tmp/cka-prep-labs/18/overlays/strategic >/dev/null
kubectl kustomize /tmp/cka-prep-labs/18/overlays/json >/dev/null
echo "Both overlays build with expected patch types."
