#!/usr/bin/env bash
set -euo pipefail
mkdir -p /tmp/cka-prep-labs
kubectl delete ns project-15a project-15b --ignore-not-found
kubectl create ns project-15a
kubectl create ns project-15b
cat <<'YAML' | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: r1
  namespace: project-15a
rules: []
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: r2
  namespace: project-15a
rules: []
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: r3
  namespace: project-15b
rules: []
YAML
rm -f /tmp/cka-prep-labs/15-role-counts.txt
echo "Exercise 15 seeded."
