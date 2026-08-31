# Exercise 08: Correct `NetworkPolicy` egress behavior

## Task

In namespace `project-snake`, create or fix `NetworkPolicy` named `np-backend` so Pods matching `app=backend` can reach:

- Pods matching `app=db1` only on TCP port `1111`
- Pods matching `app=db2` only on TCP port `2222`

Deny backend access to `vault` on port `3333`.

The seed provides a deliberately wrong policy that uses `ingress` rules and omits `ports`.

## Procedure

1. Seed the exercise:
   1. `make seed EXERCISE=8`
2. Replace the policy with the correct egress form.
3. Verify your result:
   1. `make verify EXERCISE=8`

## Gotchas

- `to` and `ports` in one egress rule create a cross product, so pair targets and ports carefully.
- If `policyTypes` is wrong, `kubectl apply` can merge unexpectedly; delete and recreate when needed.
- Use Pod labels (`app`) consistently in the policy and workload specs.
