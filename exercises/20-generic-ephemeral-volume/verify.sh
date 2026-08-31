#!/usr/bin/env bash
set -euo pipefail
kubectl -n project-20 get pod ephemeral-demo >/dev/null 2>&1 || { echo "FAIL: pod ephemeral-demo missing."; exit 1; }
claim_template="$(kubectl -n project-20 get pod ephemeral-demo -o jsonpath='{.spec.volumes[?(@.name=="scratch")].ephemeral.volumeClaimTemplate.spec.resources.requests.storage}')"
[[ -n "$claim_template" ]] || { echo "FAIL: generic ephemeral volumeClaimTemplate is missing on volume scratch."; exit 1; }
phase="$(kubectl -n project-20 get pod ephemeral-demo -o jsonpath='{.status.phase}')"
[[ "$phase" == "Running" || "$phase" == "Succeeded" ]] || { echo "FAIL: pod phase is $phase."; exit 1; }
echo "PASS: exercise 20 verification succeeded."
