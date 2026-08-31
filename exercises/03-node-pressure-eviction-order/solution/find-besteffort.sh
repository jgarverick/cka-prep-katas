#!/usr/bin/env bash
set -euo pipefail
mkdir -p /tmp/cka-prep-labs
kubectl -n project-03 get pods -o jsonpath='{range .items[?(@.status.qosClass=="BestEffort")]}{.metadata.name}{"\n"}{end}' > /tmp/cka-prep-labs/03-besteffort.txt
