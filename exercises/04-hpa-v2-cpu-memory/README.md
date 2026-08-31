# Exercise 04: Convert HPA to autoscaling/v2 with CPU and memory metrics

## Task

Create an HPA with `kubectl autoscale` for deployment `scale-me` in namespace `project-04`. Then convert it to `autoscaling/v2` and define both CPU and memory utilization metrics.

## Procedure

1. Run `make seed EXERCISE=4`.
2. Create the initial HPA with `kubectl autoscale`.
3. Convert it to `autoscaling/v2` and keep the same target deployment.
4. Add CPU and memory metric targets.
5. Run `make verify EXERCISE=4`.

## Gotchas

- `kubectl autoscale` creates a simpler object that you must edit for dual metrics.
- Keep metric `type` and nested `resource` fields aligned.
