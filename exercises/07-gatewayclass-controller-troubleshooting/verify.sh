#!/usr/bin/env bash
set -euo pipefail
gc="$(kubectl get gatewayclass nginx-typo -o jsonpath='{.spec.controllerName}')"
[[ "$gc" == "gateway.nginx.org/nginx-gateway-controller" ]] || { echo "FAIL: controllerName is still incorrect."; exit 1; }
programmed="$(kubectl -n project-gwfix get gateway broken-main -o jsonpath='{.status.conditions[?(@.type=="Programmed")].status}')"
[[ "$programmed" == "True" ]] || { echo "FAIL: Gateway Programmed condition is not True."; exit 1; }
echo "PASS: exercise 07 verification succeeded."
