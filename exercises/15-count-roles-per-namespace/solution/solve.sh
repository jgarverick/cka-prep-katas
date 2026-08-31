#!/usr/bin/env bash
set -euo pipefail
mkdir -p /tmp/cka-prep-labs
kubectl get roles -A -o jsonpath='{range .items[*]}{.metadata.namespace}{"\n"}{end}' | sort | uniq -c | awk '{print $2" "$1}' | sort > /tmp/cka-prep-labs/15-role-counts.txt
