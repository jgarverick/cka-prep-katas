#!/usr/bin/env bash
set -euo pipefail
ns=project-04
kubectl delete ns "$ns" --ignore-not-found
kubectl create ns "$ns"
cat <<'YAML' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: scale-me
  namespace: project-04
spec:
  replicas: 1
  selector:
    matchLabels:
      app: scale-me
  template:
    metadata:
      labels:
        app: scale-me
    spec:
      containers:
        - name: app
          image: nginx:1-alpine
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
YAML
kubectl -n "$ns" rollout status deployment/scale-me --timeout=180s
kubectl -n "$ns" delete hpa scale-me --ignore-not-found
echo "Exercise 04 seeded."
