# Exercise 13: Diagnose kubelet 203/EXEC

## Task

Fix simulated kubelet systemd unit `ExecStart` path at `/tmp/cka-prep-labs/13-kubelet.service`.

## Procedure

1. Run `make seed EXERCISE=13`.
2. Inspect the unit and identify bad command path.
3. Correct `ExecStart`.
4. Run `make verify EXERCISE=13`.

## Gotchas

- `203/EXEC` indicates missing or non-executable command path.
