#!/usr/bin/env bash
set -euo pipefail
kubectl delete ns project-02 --ignore-not-found
kubectl create ns project-02
echo "Exercise 02 seeded in namespace project-02."
