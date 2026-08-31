#!/usr/bin/env bash
set -euo pipefail
mkdir -p /tmp/cka-prep-labs
cat > /tmp/cka-prep-labs/10-etcd.yaml <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: etcd-control-plane
spec:
  containers:
    - name: etcd
      command:
        - etcd
        - --data-dir=/var/lib/etcd
  volumes:
    - name: etcd-data
      hostPath:
        path: /var/lib/etcd
YAML
echo "Exercise 10 seeded."
