# Exercise 09: Save and inspect an etcd snapshot

## Task

Save an etcd snapshot from the control plane to `/tmp/cka-prep-labs/etcd-snapshot.db`, then write snapshot status output to `/tmp/cka-prep-labs/09-status.txt`.

## Procedure

1. Run `make seed EXERCISE=9`.
2. Save the snapshot with correct TLS flags.
3. Run `snapshot status` with `etcdutl`.
4. Save output to `/tmp/cka-prep-labs/09-status.txt`.
5. Run `make verify EXERCISE=9`.

## Gotchas

- `ETCDCTL_API` is obsolete on etcd 3.5+.
- `etcdutl` handles status and restore in newer versions.
- `error reading server preface` usually indicates endpoint scheme, port, or cert mismatch.
