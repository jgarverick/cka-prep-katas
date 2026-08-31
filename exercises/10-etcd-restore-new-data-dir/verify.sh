#!/usr/bin/env bash
set -euo pipefail
file=/tmp/cka-prep-labs/10-etcd.yaml
grep -q -- '--data-dir=/var/lib/etcd-from-backup' "$file" || { echo "FAIL: data-dir arg not updated."; exit 1; }
grep -q 'path: /var/lib/etcd-from-backup' "$file" || { echo "FAIL: hostPath not updated."; exit 1; }
echo "PASS: exercise 10 verification succeeded."
