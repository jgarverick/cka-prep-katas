#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

CALICO_VERSION="v3.29.1"
GATEWAY_API_VERSION="v1.1.0"
NGF_VERSION="v2.2.0" # Compatible with Gateway API v1.1 standard channel.
METRICS_SERVER_VERSION="v0.7.2"

kind create cluster --name cka-practice --config "$ROOT_DIR/kind-config.yaml"

kubectl apply -f "https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/calico.yaml"
kubectl -n kube-system rollout status ds/calico-node --timeout=180s

kubectl apply -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/${GATEWAY_API_VERSION}/standard-install.yaml"
kubectl apply -f "https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/${NGF_VERSION}/deploy/crds.yaml"
kubectl apply -f "https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/${NGF_VERSION}/deploy/nodeport/deploy.yaml"

kubectl apply -f "https://github.com/kubernetes-sigs/metrics-server/releases/download/${METRICS_SERVER_VERSION}/components.yaml"
kubectl -n kube-system patch deployment metrics-server --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]' || true
kubectl -n kube-system rollout status deployment/metrics-server --timeout=180s

echo "Cluster is ready."
