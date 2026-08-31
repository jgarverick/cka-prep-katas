#!/usr/bin/env bash
set -euo pipefail

ns="project-snake"

kubectl delete ns "$ns" --ignore-not-found
kubectl create ns "$ns"

cat <<'MANIFEST' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: backend-a
  namespace: project-snake
  labels:
    app: backend
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "sleep 3600"]
---
apiVersion: v1
kind: Pod
metadata:
  name: backend-b
  namespace: project-snake
  labels:
    app: backend
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "sleep 3600"]
---
apiVersion: v1
kind: Pod
metadata:
  name: db1-a
  namespace: project-snake
  labels:
    app: db1
spec:
  containers:
    - name: netexec
      image: registry.k8s.io/e2e-test-images/agnhost:2.39
      args: ["netexec", "--http-port=1111"]
---
apiVersion: v1
kind: Pod
metadata:
  name: db2-a
  namespace: project-snake
  labels:
    app: db2
spec:
  containers:
    - name: netexec
      image: registry.k8s.io/e2e-test-images/agnhost:2.39
      args: ["netexec", "--http-port=2222"]
---
apiVersion: v1
kind: Pod
metadata:
  name: vault-a
  namespace: project-snake
  labels:
    app: vault
spec:
  containers:
    - name: netexec
      image: registry.k8s.io/e2e-test-images/agnhost:2.39
      args: ["netexec", "--http-port=3333"]
---
apiVersion: v1
kind: Service
metadata:
  name: db1
  namespace: project-snake
spec:
  selector:
    app: db1
  ports:
    - port: 1111
      targetPort: 1111
---
apiVersion: v1
kind: Service
metadata:
  name: db2
  namespace: project-snake
spec:
  selector:
    app: db2
  ports:
    - port: 2222
      targetPort: 2222
---
apiVersion: v1
kind: Service
metadata:
  name: vault
  namespace: project-snake
spec:
  selector:
    app: vault
  ports:
    - port: 3333
      targetPort: 3333
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-backend
  namespace: project-snake
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: db1
        - podSelector:
            matchLabels:
              app: db2
MANIFEST

kubectl -n "$ns" wait --for=condition=Ready pod --all --timeout=180s

echo "Exercise 08 seeded in namespace $ns."
