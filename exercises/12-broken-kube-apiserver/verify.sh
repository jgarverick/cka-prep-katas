#!/usr/bin/env bash
set -euo pipefail
docker exec cka-practice-control-plane sh -c '! grep -q -- "--bad-flag-for-lab=true" /etc/kubernetes/manifests/kube-apiserver.yaml' || { echo "FAIL: invalid flag still present."; exit 1; }
kubectl get ns kube-system >/dev/null 2>&1 || { echo "FAIL: kube-apiserver not healthy."; exit 1; }
echo "PASS: exercise 12 verification succeeded."
