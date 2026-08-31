#!/usr/bin/env bash
set -euo pipefail
file=/tmp/cka-prep-labs/03-besteffort.txt
[[ -f "$file" ]] || { echo "FAIL: $file not found."; exit 1; }
expected="$(kubectl -n project-03 get pods -o jsonpath='{range .items[?(@.status.qosClass=="BestEffort")]}{.metadata.name}{"\n"}{end}' | sort)"
actual="$(sort "$file")"
[[ "$expected" == "$actual" ]] || { echo "FAIL: expected BestEffort pod list does not match."; exit 1; }
echo "PASS: exercise 03 verification succeeded."
