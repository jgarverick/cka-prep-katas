#!/usr/bin/env bash
set -euo pipefail
node_name="$(kubectl -n project-11 get pod manual-pod -o jsonpath='{.spec.nodeName}' 2>/dev/null || true)"
[[ -n "$node_name" ]] || { echo "FAIL: manual-pod missing or nodeName empty."; exit 1; }
kubectl -n project-11 wait --for=condition=Ready pod/manual-pod --timeout=180s >/dev/null 2>&1 || { echo "FAIL: manual-pod is not Ready."; exit 1; }
docker exec cka-practice-control-plane test -f /etc/kubernetes/manifests/kube-scheduler.yaml >/dev/null 2>&1 || { echo "FAIL: scheduler manifest not restored."; exit 1; }
echo "PASS: exercise 11 verification succeeded."
