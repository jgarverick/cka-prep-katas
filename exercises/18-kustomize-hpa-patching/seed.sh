#!/usr/bin/env bash
set -euo pipefail
mkdir -p /tmp/cka-prep-labs/18/base /tmp/cka-prep-labs/18/overlays/strategic /tmp/cka-prep-labs/18/overlays/json
cat > /tmp/cka-prep-labs/18/base/hpa.yaml <<'YAML'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: app
  minReplicas: 1
  maxReplicas: 3
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
YAML
cat > /tmp/cka-prep-labs/18/base/kustomization.yaml <<'YAML'
resources:
  - hpa.yaml
YAML
cat > /tmp/cka-prep-labs/18/overlays/strategic/kustomization.yaml <<'YAML'
resources:
  - ../../base
patchesStrategicMerge:
  - hpa-patch.yaml
YAML
cat > /tmp/cka-prep-labs/18/overlays/strategic/hpa-patch.yaml <<'YAML'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: app-hpa
spec:
  maxReplicas: 6
YAML
cat > /tmp/cka-prep-labs/18/overlays/json/kustomization.yaml <<'YAML'
resources:
  - ../../base
patchesJson6902:
  - target:
      group: autoscaling
      version: v2
      kind: HorizontalPodAutoscaler
      name: app-hpa
    path: patch.json
YAML
cat > /tmp/cka-prep-labs/18/overlays/json/patch.json <<'JSON'
[
  {"op":"replace","path":"/spec/maxReplicas","value":8}
]
JSON
echo "Exercise 18 seeded."
