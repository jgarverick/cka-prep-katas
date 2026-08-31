#!/usr/bin/env bash
set -euo pipefail
ns=project-02
kubectl -n "$ns" get deploy deploy-important >/dev/null 2>&1 || { echo "FAIL: deployment deploy-important not found."; exit 1; }
replicas="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.spec.replicas}')"
[[ "$replicas" == "3" ]] || { echo "FAIL: replicas must be 3."; exit 1; }
max_skew="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].maxSkew}')"
when_unsat="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].whenUnsatisfiable}')"
topology_key="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].topologyKey}')"
[[ "$max_skew" == "1" && "$when_unsat" == "DoNotSchedule" && "$topology_key" == "kubernetes.io/hostname" ]] || { echo "FAIL: topologySpreadConstraints values are incorrect."; exit 1; }
pending_count="$(kubectl -n "$ns" get pods -l id=very-important --field-selector=status.phase=Pending --no-headers 2>/dev/null | wc -l | tr -d ' ')"
[[ "$pending_count" == "1" ]] || { echo "FAIL: expected exactly one pending pod, got $pending_count."; exit 1; }
echo "PASS: exercise 02 verification succeeded."
