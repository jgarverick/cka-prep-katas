#!/usr/bin/env bash
set -euo pipefail
ns=project-04
hpa=scale-me
kubectl -n "$ns" get hpa "$hpa" >/dev/null 2>&1 || { echo "FAIL: HPA scale-me not found."; exit 1; }
api="$(kubectl -n "$ns" get hpa "$hpa" -o jsonpath='{.apiVersion}')"
[[ "$api" == "autoscaling/v2" ]] || { echo "FAIL: apiVersion must be autoscaling/v2."; exit 1; }
cpu="$(kubectl -n "$ns" get hpa "$hpa" -o jsonpath='{.spec.metrics[?(@.resource.name=="cpu")].resource.target.averageUtilization}')"
mem="$(kubectl -n "$ns" get hpa "$hpa" -o jsonpath='{.spec.metrics[?(@.resource.name=="memory")].resource.target.averageUtilization}')"
[[ -n "$cpu" && -n "$mem" ]] || { echo "FAIL: both CPU and memory metrics are required."; exit 1; }
echo "PASS: exercise 04 verification succeeded."
