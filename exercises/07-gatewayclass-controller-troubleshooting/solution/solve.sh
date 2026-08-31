#!/usr/bin/env bash
set -euo pipefail
kubectl patch gatewayclass nginx-typo --type='merge' -p '{"spec":{"controllerName":"gateway.nginx.org/nginx-gateway-controller"}}'
