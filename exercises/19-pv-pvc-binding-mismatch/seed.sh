#!/usr/bin/env bash
set -euo pipefail
ns=project-19
kubectl delete ns "$ns" --ignore-not-found
kubectl create ns "$ns"
kubectl delete pv pv-manual-19 --ignore-not-found
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-manual-19
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual-good
  hostPath:
    path: /tmp/pv-manual-19
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: claim-19
  namespace: project-19
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: manual-bad
YAML
echo "Exercise 19 seeded."
