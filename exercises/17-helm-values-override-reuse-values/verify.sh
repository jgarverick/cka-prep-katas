#!/usr/bin/env bash
set -euo pipefail
ns=project-17
value="$(kubectl -n "$ns" get cm sample-app-config -o jsonpath='{.data.crdsEnabled}' 2>/dev/null || true)"
[[ "$value" == "false" ]] || { echo "FAIL: expected crdsEnabled=false after override and reuse-values."; exit 1; }
revisions="$(helm -n "$ns" history sample-app -o json | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))')"
(( revisions >= 2 )) || { echo "FAIL: expected at least two helm revisions."; exit 1; }
echo "PASS: exercise 17 verification succeeded."
