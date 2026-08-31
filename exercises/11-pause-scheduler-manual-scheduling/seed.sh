#!/usr/bin/env bash
set -euo pipefail
kubectl delete ns project-11 --ignore-not-found
kubectl create ns project-11
echo "Exercise 11 seeded."
