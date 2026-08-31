# Exercise 05: Fix a readiness probe exec command array

## Task

Fix deployment `probe-fix` in namespace `project-05`. The readiness probe uses one scalar-like token (`wget -T2 -O- http://svc:80`) instead of a command array.

## Procedure

1. Run `make seed EXERCISE=5`.
2. Inspect deployment `probe-fix`.
3. Replace probe command with tokenized array.
4. Run `make verify EXERCISE=5`.

## Gotchas

- For `exec.command`, each command token is a separate list element.
- A single element with spaces fails executable lookup.
