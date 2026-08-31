# Exercise 12: Recover a broken kube-apiserver

## Task

The seed adds an invalid flag to kube-apiserver static pod manifest. Diagnose and fix it using node-level tools when API is unavailable.

## Procedure

1. Run `make seed EXERCISE=12`.
2. Inspect failures with `crictl ps -a`, `crictl logs`, and `journalctl -u kubelet`.
3. Remove invalid flag from kube-apiserver manifest.
4. Run `make verify EXERCISE=12`.

## Gotchas

- `kubectl` might be unavailable until API recovers.
