#!/usr/bin/env bash
set -euo pipefail
ns=project-05
command_count="$(kubectl -n "$ns" get deploy probe-fix -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.exec.command[*]}' | wc -w | tr -d ' ')"
(( command_count >= 4 )) || { echo "FAIL: readiness command is not tokenized into multiple arguments."; exit 1; }
ready="$(kubectl -n "$ns" get pods -l app=probe-fix -o jsonpath='{.items[0].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || true)"
[[ "$ready" == "True" ]] || { echo "FAIL: probe-fix pod is not Ready."; exit 1; }
echo "PASS: exercise 05 verification succeeded."
