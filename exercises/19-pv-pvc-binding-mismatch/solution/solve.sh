#!/usr/bin/env bash
set -euo pipefail
kubectl -n project-19 delete pvc claim-19 --ignore-not-found
cat <<'YAML' | kubectl apply -f -
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
  storageClassName: manual-good
YAML
