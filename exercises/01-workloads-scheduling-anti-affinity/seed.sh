#!/usr/bin/env bash
set -euo pipefail

kubectl delete ns project-01 --ignore-not-found
kubectl create ns project-01

echo "Exercise 01 seeded in namespace project-01."
