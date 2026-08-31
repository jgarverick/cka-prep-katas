# Exercise 03: Identify pods evicted first under pressure

## Task

Find which pods would be evicted first on a pressured node based on QoS class. Write the `BestEffort` pod names to `/tmp/cka-prep-labs/03-besteffort.txt`, one name per line.

## Procedure

1. Run `make seed EXERCISE=3`.
2. Find pod QoS classes in namespace `project-03`.
3. Write only `BestEffort` pod names to `/tmp/cka-prep-labs/03-besteffort.txt`.
4. Run `make verify EXERCISE=3`.

## Gotchas

- `BestEffort` pods have no resource requests and no limits.
- `Guaranteed` pods require equal request and limit for every container resource.
