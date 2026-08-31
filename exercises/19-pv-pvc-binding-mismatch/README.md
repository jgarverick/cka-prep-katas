# Exercise 19: Resolve PV/PVC storageClass mismatch

## Task

A PVC in `project-19` remains `Pending` because of storageClass mismatch. Fix it so the claim binds to the manual PV.

## Procedure

1. Run `make seed EXERCISE=19`.
2. Compare PV and PVC `storageClassName` values.
3. Recreate or patch the PVC to match the PV class.
4. Run `make verify EXERCISE=19`.

## Gotchas

- You cannot mutate every PVC field in place after creation.
