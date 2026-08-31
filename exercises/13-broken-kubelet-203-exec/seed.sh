#!/usr/bin/env bash
set -euo pipefail
mkdir -p /tmp/cka-prep-labs
cat > /tmp/cka-prep-labs/13-kubelet.service <<'UNIT'
[Service]
ExecStart=/usr/bin/kublet --config=/var/lib/kubelet/config.yaml
UNIT
echo "Exercise 13 seeded."
