#!/usr/bin/env bash
set -euo pipefail
sed -i 's#/var/lib/etcd#/var/lib/etcd-from-backup#g' /tmp/cka-prep-labs/10-etcd.yaml
