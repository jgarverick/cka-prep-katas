#!/usr/bin/env bash
set -euo pipefail
mkdir -p /tmp/cka-prep-labs
openssl req -x509 -newkey rsa:2048 -nodes -subj "/CN=cka-user" -addext "extendedKeyUsage=clientAuth" -keyout /tmp/cka-prep-labs/16-key.pem -out /tmp/cka-prep-labs/16-cert.pem -days 365 >/dev/null 2>&1
cert_b64="$(base64 -w0 /tmp/cka-prep-labs/16-cert.pem)"
cat > /tmp/cka-prep-labs/16-kubeconfig.yaml <<EOF_CFG
apiVersion: v1
kind: Config
users:
- name: cka-user
  user:
    client-certificate-data: ${cert_b64}
EOF_CFG
rm -f /tmp/cka-prep-labs/16-cert-report.txt
echo "Exercise 16 seeded."
