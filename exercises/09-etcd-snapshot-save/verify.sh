#!/usr/bin/env bash
set -euo pipefail
[[ -s /tmp/cka-prep-labs/etcd-snapshot.db ]] || { echo "FAIL: snapshot file missing or empty."; exit 1; }
[[ -s /tmp/cka-prep-labs/09-status.txt ]] || { echo "FAIL: status output file missing."; exit 1; }
grep -Eq 'TOTAL SIZE|HASH|REVISION' /tmp/cka-prep-labs/09-status.txt || { echo "FAIL: status output missing expected fields."; exit 1; }
echo "PASS: exercise 09 verification succeeded."
