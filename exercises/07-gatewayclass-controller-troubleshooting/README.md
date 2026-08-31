# Exercise 07: Fix a GatewayClass controller typo

## Task

A Gateway in namespace `project-gwfix` never receives an address because its GatewayClass controller name is typoed. Fix the GatewayClass so the Gateway becomes programmed.

## Procedure

1. Run `make seed EXERCISE=7`.
2. Inspect GatewayClass and Gateway conditions.
3. Correct `spec.controllerName`.
4. Run `make verify EXERCISE=7`.

## Gotchas

- You must fix `GatewayClass`, not only `Gateway`.
- Verify `Programmed=True` on the Gateway.
