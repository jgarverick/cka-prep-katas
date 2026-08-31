#!/usr/bin/env bash
set -euo pipefail
ns=project-gwfix
kubectl delete ns "$ns" --ignore-not-found
kubectl create ns "$ns"
kubectl delete gatewayclass nginx-typo --ignore-not-found
cat <<'YAML' | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-typo
spec:
  controllerName: gateway.nginx.org/nginx-gateway-controllre
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: broken-main
  namespace: project-gwfix
spec:
  gatewayClassName: nginx-typo
  listeners:
    - name: http
      protocol: HTTP
      port: 80
YAML
echo "Exercise 07 seeded."
