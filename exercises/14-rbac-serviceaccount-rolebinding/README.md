# Exercise 14: Create ServiceAccount, Role, and RoleBinding

## Task

In namespace `project-rbac`, create:

- ServiceAccount `app-sa`
- Role `pod-reader` with `get` and `list` on pods
- RoleBinding `app-sa-pod-reader`

## Procedure

1. Run `make seed EXERCISE=14`.
2. Create the RBAC resources.
3. Validate with `kubectl auth can-i`.
4. Run `make verify EXERCISE=14`.

## Gotchas

- RoleBinding subject namespace must match ServiceAccount namespace.
