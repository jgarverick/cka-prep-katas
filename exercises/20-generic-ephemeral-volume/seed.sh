#!/usr/bin/env bash
set -euo pipefail
kubectl delete ns project-20 --ignore-not-found
kubectl create ns project-20
echo "Exercise 20 seeded."
