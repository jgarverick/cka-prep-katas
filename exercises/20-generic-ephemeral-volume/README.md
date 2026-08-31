# Exercise 20: Create a pod with generic ephemeral volume

## Task

Create pod `ephemeral-demo` in namespace `project-20` using inline generic ephemeral volume in `volumes[].ephemeral.volumeClaimTemplate`.

## Procedure

1. Run `make seed EXERCISE=20`.
2. Create the pod with an inline claim template.
3. Run `make verify EXERCISE=20`.

## Gotchas

- Generic ephemeral volumes are PVC-backed and lifecycle-bound to the pod.
