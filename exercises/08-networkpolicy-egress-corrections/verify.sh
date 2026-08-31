#!/usr/bin/env bash
set -euo pipefail

ns="project-snake"

if ! kubectl -n "$ns" get networkpolicy np-backend >/dev/null 2>&1; then
  echo "FAIL: NetworkPolicy np-backend was not found."
  exit 1
fi

policy_types="$(kubectl -n "$ns" get networkpolicy np-backend -o jsonpath='{.spec.policyTypes[*]}')"
if [[ "$policy_types" != *Egress* ]]; then
  echo "FAIL: expected policyTypes to include Egress."
  exit 1
fi

if ! kubectl -n "$ns" get networkpolicy np-backend -o json | python3 -c '
import json, sys
obj = json.load(sys.stdin)
ok = False
for rule in obj.get("spec", {}).get("egress", []):
    apps = [t.get("podSelector", {}).get("matchLabels", {}).get("app") for t in rule.get("to", [])]
    ports = [str(p.get("port")) for p in rule.get("ports", [])]
    if "db1" in apps and "1111" in ports:
        ok = True
        break
sys.exit(0 if ok else 1)
'; then
  echo "FAIL: expected egress allowance to db1 on port 1111."
  exit 1
fi
if ! kubectl -n "$ns" get networkpolicy np-backend -o json | python3 -c '
import json, sys
obj = json.load(sys.stdin)
ok = False
for rule in obj.get("spec", {}).get("egress", []):
    apps = [t.get("podSelector", {}).get("matchLabels", {}).get("app") for t in rule.get("to", [])]
    ports = [str(p.get("port")) for p in rule.get("ports", [])]
    if "db2" in apps and "2222" in ports:
        ok = True
        break
sys.exit(0 if ok else 1)
'; then
  echo "FAIL: expected egress allowance to db2 on port 2222."
  exit 1
fi

backend_pod="$(kubectl -n "$ns" get pod -l app=backend -o jsonpath='{.items[0].metadata.name}')"
if [[ -z "$backend_pod" ]]; then
  echo "FAIL: no backend pod found with label app=backend."
  exit 1
fi

if ! kubectl -n "$ns" exec "$backend_pod" -- sh -c 'wget -T2 -qO- http://db1:1111/hostname >/dev/null'; then
  echo "FAIL: backend cannot reach db1:1111."
  exit 1
fi

if ! kubectl -n "$ns" exec "$backend_pod" -- sh -c 'wget -T2 -qO- http://db2:2222/hostname >/dev/null'; then
  echo "FAIL: backend cannot reach db2:2222."
  exit 1
fi

if kubectl -n "$ns" exec "$backend_pod" -- sh -c 'wget -T2 -qO- http://vault:3333/hostname >/dev/null'; then
  echo "FAIL: backend should NOT reach vault:3333, but request succeeded."
  exit 1
fi

echo "PASS: exercise 08 verification succeeded."
