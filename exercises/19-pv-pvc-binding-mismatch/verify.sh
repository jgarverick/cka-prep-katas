#!/usr/bin/env bash
set -euo pipefail
phase="$(kubectl -n project-19 get pvc claim-19 -o jsonpath='{.status.phase}')"
[[ "$phase" == "Bound" ]] || { echo "FAIL: PVC claim-19 is not Bound."; exit 1; }
pv="$(kubectl -n project-19 get pvc claim-19 -o jsonpath='{.spec.volumeName}')"
[[ "$pv" == "pv-manual-19" ]] || { echo "FAIL: PVC bound to unexpected PV: $pv"; exit 1; }
echo "PASS: exercise 19 verification succeeded."
