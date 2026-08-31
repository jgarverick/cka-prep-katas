#!/usr/bin/env bash
set -euo pipefail
ns=project-rbac
kubectl -n "$ns" get sa app-sa >/dev/null 2>&1 || { echo "FAIL: app-sa missing."; exit 1; }
kubectl -n "$ns" get role pod-reader >/dev/null 2>&1 || { echo "FAIL: pod-reader missing."; exit 1; }
kubectl -n "$ns" get rolebinding app-sa-pod-reader >/dev/null 2>&1 || { echo "FAIL: rolebinding missing."; exit 1; }
can_i="$(kubectl auth can-i --as=system:serviceaccount:project-rbac:app-sa get pods -n project-rbac)"
[[ "$can_i" == "yes" ]] || { echo "FAIL: expected can-i yes."; exit 1; }
echo "PASS: exercise 14 verification succeeded."
