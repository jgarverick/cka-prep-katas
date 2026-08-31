#!/usr/bin/env bash
set -euo pipefail
docker exec cka-practice-control-plane sh -c '
cp -f /etc/kubernetes/manifests/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml.bak
if ! grep -q -- "--bad-flag-for-lab=true" /etc/kubernetes/manifests/kube-apiserver.yaml; then
  sed -i "s#- kube-apiserver#- kube-apiserver\\n    - --bad-flag-for-lab=true#" /etc/kubernetes/manifests/kube-apiserver.yaml
fi
'
echo "Exercise 12 seeded."
