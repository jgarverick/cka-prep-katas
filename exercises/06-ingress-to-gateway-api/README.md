# Exercise 06: Replace Ingress with Gateway API routes

## Task

In namespace `project-r500`, the seed creates a Gateway named `main`, plus an old Ingress and two backend Services named `desktop` and `mobile`.

Create an `HTTPRoute` named `traffic-director` that attaches to Gateway `main` and replicates these routes:

- `/desktop` routes to Service `desktop` on port `80`
- `/mobile` routes to Service `mobile` on port `80`

Add a new `/auto` route:

- Route to `mobile` when header `User-Agent` is exactly `mobile`
- Route to `desktop` for all other requests

Use hostname `r500.gateway`.

## Procedure

1. Seed the exercise:
   1. `make seed EXERCISE=6`
2. Create the `HTTPRoute`.
3. Verify your result:
   1. `make verify EXERCISE=6`

## Gotchas

- Keep `/auto` header-specific and fallback behavior in separate ordered rules.
- Set `parentRefs` to the existing Gateway `main` in the same namespace.
- Set the route `hostnames` so matching uses `r500.gateway`.
