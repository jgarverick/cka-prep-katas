#!/usr/bin/env bash
set -euo pipefail
kubectl -n project-04 autoscale deployment scale-me --cpu-percent=70 --min=1 --max=5 >/dev/null 2>&1 || true
kubectl apply -f "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/hpa.yaml"
