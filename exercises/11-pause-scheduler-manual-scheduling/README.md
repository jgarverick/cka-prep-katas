# Exercise 11: Pause scheduler and schedule a pod manually

## Task

Pause scheduler behavior by moving its static pod manifest, schedule one pod with `spec.nodeName`, then restore scheduler manifest.

## Procedure

1. Run `make seed EXERCISE=11`.
2. Move scheduler manifest out of `/etc/kubernetes/manifests/`.
3. Create pod `manual-pod` in `project-11` with `spec.nodeName`.
4. Restore scheduler manifest.
5. Run `make verify EXERCISE=11`.

## Gotchas

- Restoring scheduler manifest is required to finish correctly.
