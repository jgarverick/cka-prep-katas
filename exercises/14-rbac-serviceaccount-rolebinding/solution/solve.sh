#!/usr/bin/env bash
set -euo pipefail
kubectl apply -f "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/rbac.yaml"
