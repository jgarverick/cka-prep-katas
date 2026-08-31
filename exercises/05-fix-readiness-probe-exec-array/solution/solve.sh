#!/usr/bin/env bash
set -euo pipefail
kubectl -n project-05 patch deployment probe-fix --type='json' -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/exec/command","value":["wget","-T2","-O-","http://svc:80"]}]'
