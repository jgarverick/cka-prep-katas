# Exercise 17: Use Helm values precedence and reuse-values

## Task

Install chart `sample-app` in namespace `project-17` with this sequence:

1. `--set crds.enabled=true`
2. override with `-f values.yaml` setting it to `false`
3. run `helm upgrade --reuse-values`

## Procedure

1. Run `make seed EXERCISE=17`.
2. Install and upgrade release `sample-app`.
3. Run `make verify EXERCISE=17`.

## Gotchas

- Value precedence applies per command invocation.
- `--reuse-values` carries effective values forward.
