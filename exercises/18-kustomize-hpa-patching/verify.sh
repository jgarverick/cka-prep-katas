#!/usr/bin/env bash
set -euo pipefail
strategic="$(kubectl kustomize /tmp/cka-prep-labs/18/overlays/strategic | awk '/maxReplicas:/ {print $2; exit}')"
json="$(kubectl kustomize /tmp/cka-prep-labs/18/overlays/json | awk '/maxReplicas:/ {print $2; exit}')"
[[ "$strategic" == "6" ]] || { echo "FAIL: strategic overlay maxReplicas is not 6."; exit 1; }
[[ "$json" == "8" ]] || { echo "FAIL: json overlay maxReplicas is not 8."; exit 1; }
echo "PASS: exercise 18 verification succeeded."
