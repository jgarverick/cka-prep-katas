#!/usr/bin/env bash
set -euo pipefail
file=/tmp/cka-prep-labs/16-cert-report.txt
[[ -s "$file" ]] || { echo "FAIL: report file missing."; exit 1; }
grep -qi 'Subject:' "$file" || { echo "FAIL: Subject missing."; exit 1; }
grep -qi 'Issuer:' "$file" || { echo "FAIL: Issuer missing."; exit 1; }
grep -Eq 'Not Before|notBefore' "$file" || { echo "FAIL: notBefore missing."; exit 1; }
grep -Eq 'Not After|notAfter' "$file" || { echo "FAIL: notAfter missing."; exit 1; }
grep -qi 'Extended Key Usage' "$file" || { echo "FAIL: EKU missing."; exit 1; }
echo "PASS: exercise 16 verification succeeded."
