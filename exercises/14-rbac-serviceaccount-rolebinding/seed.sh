#!/usr/bin/env bash
set -euo pipefail
kubectl delete ns project-rbac --ignore-not-found
kubectl create ns project-rbac
echo "Exercise 14 seeded."
