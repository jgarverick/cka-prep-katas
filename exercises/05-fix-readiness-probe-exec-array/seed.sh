#!/usr/bin/env bash
set -euo pipefail
ns=project-05
kubectl delete ns "$ns" --ignore-not-found
kubectl create ns "$ns"
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: svc-target
  namespace: project-05
  labels:
    app: svc-target
spec:
  containers:
    - name: nginx
      image: nginx:1-alpine
---
apiVersion: v1
kind: Service
metadata:
  name: svc
  namespace: project-05
spec:
  selector:
    app: svc-target
  ports:
    - port: 80
      targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe-fix
  namespace: project-05
spec:
  replicas: 1
  selector:
    matchLabels:
      app: probe-fix
  template:
    metadata:
      labels:
        app: probe-fix
    spec:
      containers:
        - name: app
          image: busybox:1.36
          command: ["sh","-c","sleep 3600"]
          readinessProbe:
            exec:
              command: ["wget -T2 -O- http://svc:80"]
            initialDelaySeconds: 2
            periodSeconds: 5
YAML
kubectl -n "$ns" rollout status deployment/probe-fix --timeout=180s >/dev/null 2>&1 || true
echo "Exercise 05 seeded."
