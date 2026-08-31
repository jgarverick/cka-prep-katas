#!/usr/bin/env bash
set -euo pipefail

ns="project-r500"

if ! kubectl -n "$ns" get httproute traffic-director >/dev/null 2>&1; then
  echo "FAIL: HTTPRoute traffic-director was not found in $ns."
  exit 1
fi

parent="$(kubectl -n "$ns" get httproute traffic-director -o jsonpath='{.spec.parentRefs[0].name}')"
host="$(kubectl -n "$ns" get httproute traffic-director -o jsonpath='{.spec.hostnames[0]}')"
if [[ "$parent" != "main" || "$host" != "r500.gateway" ]]; then
  echo "FAIL: expected parentRefs[0].name=main and hostnames[0]=r500.gateway."
  exit 1
fi

if ! kubectl -n "$ns" get httproute traffic-director -o json | python3 -c '
import json, sys
obj = json.load(sys.stdin)
ok = False
for rule in obj.get("spec", {}).get("rules", []):
    paths = [m.get("path", {}).get("value") for m in rule.get("matches", [])]
    backends = [b.get("name") for b in rule.get("backendRefs", [])]
    if "/desktop" in paths and "desktop" in backends:
        ok = True
        break
sys.exit(0 if ok else 1)
'; then
  echo "FAIL: missing /desktop route to desktop service."
  exit 1
fi
if ! kubectl -n "$ns" get httproute traffic-director -o json | python3 -c '
import json, sys
obj = json.load(sys.stdin)
ok = False
for rule in obj.get("spec", {}).get("rules", []):
    paths = [m.get("path", {}).get("value") for m in rule.get("matches", [])]
    backends = [b.get("name") for b in rule.get("backendRefs", [])]
    if "/mobile" in paths and "mobile" in backends:
        ok = True
        break
sys.exit(0 if ok else 1)
'; then
  echo "FAIL: missing /mobile route to mobile service."
  exit 1
fi
if ! kubectl -n "$ns" get httproute traffic-director -o json | python3 -c '
import json, sys
obj = json.load(sys.stdin)
ok = False
for rule in obj.get("spec", {}).get("rules", []):
    for match in rule.get("matches", []):
        if match.get("path", {}).get("value") != "/auto":
            continue
        for header in match.get("headers", []):
            if header.get("name") == "User-Agent" and header.get("value") == "mobile":
                ok = True
                break
        if ok:
            break
    if ok:
        break
sys.exit(0 if ok else 1)
'; then
  echo "FAIL: missing /auto exact User-Agent=mobile match."
  exit 1
fi

svc="$(kubectl -n nginx-gateway get svc -l gateway.networking.k8s.io/gateway-name=main -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
if [[ -z "$svc" ]]; then
  echo "FAIL: no Gateway data-plane service found for gateway main."
  exit 1
fi

nodeport="$(kubectl -n nginx-gateway get svc "$svc" -o jsonpath='{.spec.ports[?(@.port==80)].nodePort}' 2>/dev/null || true)"
if [[ -z "$nodeport" ]]; then
  echo "FAIL: could not find NodePort for gateway service $svc."
  exit 1
fi

curl_base=(curl -sS --max-time 5 -H "Host: r500.gateway")
desktop_resp="$("${curl_base[@]}" "http://127.0.0.1:${nodeport}/desktop" || true)"
mobile_resp="$("${curl_base[@]}" "http://127.0.0.1:${nodeport}/mobile" || true)"
auto_mobile_resp="$(curl -sS --max-time 5 -H "Host: r500.gateway" -H "User-Agent: mobile" "http://127.0.0.1:${nodeport}/auto" || true)"
auto_default_resp="$("${curl_base[@]}" "http://127.0.0.1:${nodeport}/auto" || true)"

if [[ "$desktop_resp" != *desktop* ]]; then
  echo "FAIL: /desktop did not route to desktop backend (response: $desktop_resp)."
  exit 1
fi
if [[ "$mobile_resp" != *mobile* ]]; then
  echo "FAIL: /mobile did not route to mobile backend (response: $mobile_resp)."
  exit 1
fi
if [[ "$auto_mobile_resp" != *mobile* ]]; then
  echo "FAIL: /auto with User-Agent=mobile did not route to mobile backend (response: $auto_mobile_resp)."
  exit 1
fi
if [[ "$auto_default_resp" != *desktop* ]]; then
  echo "FAIL: /auto default route did not route to desktop backend (response: $auto_default_resp)."
  exit 1
fi

echo "PASS: exercise 06 verification succeeded."
