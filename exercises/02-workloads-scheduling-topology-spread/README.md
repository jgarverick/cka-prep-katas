# Exercise 02: Schedule with topology spread constraints

## Task

Recreate the placement goal from exercise 01, but use `topologySpreadConstraints` instead of pod anti-affinity.

Use these values:

- `maxSkew: 1`
- `topologyKey: kubernetes.io/hostname`
- `whenUnsatisfiable: DoNotSchedule`

## Approach contrast

- Pod anti-affinity expresses pairwise pod repulsion based on labels.
- Topology spread constraints express distribution balance across topology domains.
- Both approaches can leave one Pod `Pending` when the cluster has two workers and you request three replicas with one-per-node behavior.

## Procedure

1. Run `make seed EXERCISE=2`.
2. Apply your manifests.
3. Run `make verify EXERCISE=2`.

## Gotchas

- The selector in each spread constraint controls which Pods count toward skew.
- `ScheduleAnyway` does not enforce hard placement limits; use `DoNotSchedule` here.
