#!/usr/bin/env bash
set -euo pipefail
ns=project-03
kubectl delete ns "$ns" --ignore-not-found
kubectl create ns "$ns"
mkdir -p /tmp/cka-prep-labs
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: besteffort-a
  namespace: project-03
spec:
  containers:
    - name: c
      image: busybox:1.36
      command: ["sh","-c","sleep 3600"]
---
apiVersion: v1
kind: Pod
metadata:
  name: besteffort-b
  namespace: project-03
spec:
  containers:
    - name: c
      image: busybox:1.36
      command: ["sh","-c","sleep 3600"]
---
apiVersion: v1
kind: Pod
metadata:
  name: burstable-a
  namespace: project-03
spec:
  containers:
    - name: c
      image: busybox:1.36
      command: ["sh","-c","sleep 3600"]
      resources:
        requests:
          cpu: 50m
          memory: 32Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: guaranteed-a
  namespace: project-03
spec:
  containers:
    - name: c
      image: busybox:1.36
      command: ["sh","-c","sleep 3600"]
      resources:
        requests:
          cpu: 100m
          memory: 64Mi
        limits:
          cpu: 100m
          memory: 64Mi
YAML
kubectl -n "$ns" wait --for=condition=Ready pod --all --timeout=180s
rm -f /tmp/cka-prep-labs/03-besteffort.txt
echo "Exercise 03 seeded."
