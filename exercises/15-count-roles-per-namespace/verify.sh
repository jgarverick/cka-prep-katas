#!/usr/bin/env bash
set -euo pipefail
file=/tmp/cka-prep-labs/15-role-counts.txt
[[ -f "$file" ]] || { echo "FAIL: output file missing."; exit 1; }
expected="$(kubectl get roles -A -o jsonpath='{range .items[*]}{.metadata.namespace}{"\n"}{end}' | sort | uniq -c | awk '{print $2" "$1}' | sort)"
actual="$(sort "$file")"
[[ "$expected" == "$actual" ]] || { echo "FAIL: role counts mismatch."; exit 1; }
echo "PASS: exercise 15 verification succeeded."
