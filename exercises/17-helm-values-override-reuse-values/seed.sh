#!/usr/bin/env bash
set -euo pipefail
ns=project-17
kubectl delete ns "$ns" --ignore-not-found
kubectl create ns "$ns"
mkdir -p /tmp/cka-prep-labs/17-chart/templates
cat > /tmp/cka-prep-labs/17-chart/Chart.yaml <<'CH'
apiVersion: v2
name: sample-app
version: 0.1.0
CH
cat > /tmp/cka-prep-labs/17-chart/values.yaml <<'V'
crds:
  enabled: false
message: hello
V
cat > /tmp/cka-prep-labs/17-chart/templates/cm.yaml <<'T'
apiVersion: v1
kind: ConfigMap
metadata:
  name: sample-app-config
  namespace: {{ .Release.Namespace }}
data:
  crdsEnabled: "{{ .Values.crds.enabled }}"
  message: "{{ .Values.message }}"
T
helm -n "$ns" uninstall sample-app >/dev/null 2>&1 || true
echo "Exercise 17 seeded."
