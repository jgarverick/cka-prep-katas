#!/usr/bin/env bash
set -euo pipefail

ns="project-01"

if ! kubectl get ns "$ns" >/dev/null 2>&1; then
  echo "FAIL: namespace $ns does not exist."
  exit 1
fi

if ! kubectl -n "$ns" get deploy deploy-important >/dev/null 2>&1; then
  echo "FAIL: deployment deploy-important was not found."
  exit 1
fi

replicas="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.spec.replicas}')"
if [[ "$replicas" != "3" ]]; then
  echo "FAIL: expected replicas=3, got $replicas."
  exit 1
fi

deploy_label="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.metadata.labels.id}')"
pod_label="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.spec.template.metadata.labels.id}')"
if [[ "$deploy_label" != "very-important" || "$pod_label" != "very-important" ]]; then
  echo "FAIL: expected label id=very-important on Deployment and Pod template."
  exit 1
fi

c1_image="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.spec.template.spec.containers[?(@.name=="container1")].image}')"
c2_image="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.spec.template.spec.containers[?(@.name=="container2")].image}')"
if [[ "$c1_image" != "nginx:1-alpine" || "$c2_image" != "registry.k8s.io/pause:3.10" ]]; then
  echo "FAIL: expected container images nginx:1-alpine and registry.k8s.io/pause:3.10."
  exit 1
fi

topology="$(kubectl -n "$ns" get deploy deploy-important -o jsonpath='{.spec.template.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[0].topologyKey}')"
if [[ "$topology" != "kubernetes.io/hostname" ]]; then
  echo "FAIL: expected required pod anti-affinity with topologyKey kubernetes.io/hostname."
  exit 1
fi

pending_count="$(kubectl -n "$ns" get pods -l id=very-important --field-selector=status.phase=Pending --no-headers 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$pending_count" != "1" ]]; then
  echo "FAIL: expected exactly 1 Pending pod, got $pending_count."
  exit 1
fi

echo "PASS: exercise 01 verification succeeded."
