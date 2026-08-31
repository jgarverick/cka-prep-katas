# Exercise 15: Count Roles per namespace

## Task

Count `Role` objects by namespace and write output to `/tmp/cka-prep-labs/15-role-counts.txt` in format `<namespace> <count>`.

## Procedure

1. Run `make seed EXERCISE=15`.
2. Generate the counts.
3. Run `make verify EXERCISE=15`.

## Gotchas

- Count namespaced `Role` resources, not `ClusterRole`.
