# Exercise 01: Schedule with pod anti-affinity

## Task

Create a Deployment named `deploy-important` in namespace `project-01` with these requirements:

- `replicas: 3`
- Label `id=very-important` on the Deployment and on Pod template labels
- Two containers in each Pod:
  - `container1` uses image `nginx:1-alpine`
  - `container2` uses image `registry.k8s.io/pause:3.10`
- Required pod anti-affinity with `topologyKey: kubernetes.io/hostname` so Pods do not share a node

Because the practice cluster has two worker nodes, one Pod should remain `Pending`.

## Procedure

1. Seed the exercise:
   1. `make seed EXERCISE=1`
2. Create or apply the Deployment.
3. Verify your result:
   1. `make verify EXERCISE=1`

## Gotchas

- Put `id=very-important` in both Deployment metadata labels and Pod template labels.
- Use `requiredDuringSchedulingIgnoredDuringExecution`, not preferred anti-affinity.
- Apply anti-affinity to `spec.template.spec.affinity`, not Deployment-level metadata.
