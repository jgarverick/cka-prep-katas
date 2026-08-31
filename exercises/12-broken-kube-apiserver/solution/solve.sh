#!/usr/bin/env bash
set -euo pipefail
docker exec cka-practice-control-plane sh -c "sed -i '/--bad-flag-for-lab=true/d' /etc/kubernetes/manifests/kube-apiserver.yaml"
