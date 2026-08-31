# Exercise 18: Patch HPA with strategic merge and JSON 6902

## Task

Build two overlays from `/tmp/cka-prep-labs/18`:

- strategic merge overlay sets `maxReplicas: 6`
- JSON 6902 overlay sets `maxReplicas: 8`

## Procedure

1. Run `make seed EXERCISE=18`.
2. Build each overlay with `kubectl kustomize`.
3. Confirm each output has the expected `maxReplicas`.
4. Run `make verify EXERCISE=18`.

## Gotchas

- JSON patch path must match the exact target field.
