#!/usr/bin/env bash
set -euo pipefail
chart=/tmp/cka-prep-labs/17-chart
ns=project-17
helm upgrade --install sample-app "$chart" -n "$ns" --set crds.enabled=true
helm upgrade --install sample-app "$chart" -n "$ns" -f "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/values-override.yaml"
helm upgrade sample-app "$chart" -n "$ns" --reuse-values
