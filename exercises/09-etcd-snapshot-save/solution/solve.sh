#!/usr/bin/env bash
set -euo pipefail
cat <<'CMD'
# Example flow:
# docker exec cka-practice-control-plane sh -c 'ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /tmp/etcd-snapshot.db'
# docker cp cka-practice-control-plane:/tmp/etcd-snapshot.db /tmp/cka-prep-labs/etcd-snapshot.db
# etcdutl snapshot status /tmp/cka-prep-labs/etcd-snapshot.db > /tmp/cka-prep-labs/09-status.txt
CMD
