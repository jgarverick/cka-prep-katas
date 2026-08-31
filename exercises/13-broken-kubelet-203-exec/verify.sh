#!/usr/bin/env bash
set -euo pipefail
grep -q '^ExecStart=/usr/bin/kubelet ' /tmp/cka-prep-labs/13-kubelet.service || { echo "FAIL: ExecStart path still incorrect."; exit 1; }
echo "PASS: exercise 13 verification succeeded."
