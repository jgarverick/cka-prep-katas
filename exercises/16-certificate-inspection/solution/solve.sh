#!/usr/bin/env bash
set -euo pipefail
awk '/client-certificate-data:/ {print $2}' /tmp/cka-prep-labs/16-kubeconfig.yaml | base64 -d > /tmp/cka-prep-labs/16-cert-decoded.pem
openssl x509 -in /tmp/cka-prep-labs/16-cert-decoded.pem -text -noout > /tmp/cka-prep-labs/16-cert-report.txt
