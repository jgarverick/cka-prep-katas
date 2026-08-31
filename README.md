# CKA prep katas

This repository gives you repeatable, self-contained CKA-style exercises on a local `kind` cluster. You seed an exercise, solve it under a timer, and verify your result with cluster-state assertions.

## Prerequisites

Install these tools:

1. `docker`
2. `kind`
3. `kubectl`
4. `curl`
5. `helm`
6. `jq` (optional, for ad-hoc inspection)

## Quickstart

1. Create the cluster and install components:
   1. `make cluster-up`
2. Seed an exercise:
   1. `make seed EXERCISE=1`
3. Solve it manually or apply the reference:
   1. `make solve EXERCISE=1`
4. Verify and record your attempt:
   1. `make verify EXERCISE=1`
5. Tear down when finished:
   1. `make cluster-down`

## Environment setup

Load the exam shell helpers:

- `source scripts/env.sh`

This script sets:

- `alias k=kubectl`
- `export do="--dry-run=client -o yaml"`
- `export now="--force --grace-period=0"`
- `kubectl` Bash completion and alias completion
- A `.vimrc` snippet: `set expandtab tabstop=2 shiftwidth=2`

## Cluster profile

The cluster runs on `kind` with one control-plane node and two workers. The bootstrap installs:

1. Calico CNI for real `NetworkPolicy` enforcement
2. Gateway API standard channel CRDs
3. NGINX Gateway Fabric
4. `metrics-server` for HPA exercises

## Timer and progress tracking

- `make seed EXERCISE=n` starts the exercise timer from `meta.yaml`.
- `make verify EXERCISE=n` stops the timer, reports elapsed time, checks budget, and logs the result.
- `make timer-stop` stops any running timer.
- `make timer-status` shows elapsed and remaining time.
- `make stats` prints attempt stats by exercise.
- `make exam` runs randomized exercises under one 120-minute exam clock.

Attempts are logged to `.progress/history.tsv` with exercise ID, timestamp, elapsed seconds, timeout, and pass or fail.

## Exercise index by CKA domain

### Cluster architecture, installation, and configuration (25%)

- `09-etcd-snapshot-save`
- `10-etcd-restore-new-data-dir`
- `11-pause-scheduler-manual-scheduling`
- `12-broken-kube-apiserver`
- `13-broken-kubelet-203-exec`
- `16-certificate-inspection`

### Workloads and scheduling (15%)

- `01-workloads-scheduling-anti-affinity`
- `02-workloads-scheduling-topology-spread`
- `03-node-pressure-eviction-order`
- `04-hpa-v2-cpu-memory`
- `05-fix-readiness-probe-exec-array`

### Services and networking (20%)

- `06-ingress-to-gateway-api`
- `07-gatewayclass-controller-troubleshooting`
- `08-networkpolicy-egress-corrections`

### Storage (10%)

- `19-pv-pvc-binding-mismatch`
- `20-generic-ephemeral-volume`

### Troubleshooting and RBAC focused tasks (30%)

- `14-rbac-serviceaccount-rolebinding`
- `15-count-roles-per-namespace`
- `17-helm-values-override-reuse-values`
- `18-kustomize-hpa-patching`

Use exercises `01`, `06`, and `08` as full reference implementations. The remaining directories contain scaffold files and time budgets that you can expand.
