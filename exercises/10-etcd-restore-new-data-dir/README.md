# Exercise 10: Restore etcd to a new data directory

## Task

Restore etcd to a new data directory. Update both `--data-dir` and the data `hostPath` in the lab manifest `/tmp/cka-prep-labs/10-etcd.yaml`.

## Procedure

1. Run `make seed EXERCISE=10`.
2. Edit `/tmp/cka-prep-labs/10-etcd.yaml`.
3. Change both paths to `/var/lib/etcd-from-backup`.
4. Run `make verify EXERCISE=10`.

## Gotchas

- Update command args and volume path together.
