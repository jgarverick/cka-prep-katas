# CKA cheatsheet

## Generate common resources

- `k create deploy web --image=nginx --replicas=3 $do > deploy.yaml`
- `k expose deploy web --port=80 --target-port=80 --name=web-svc $do > svc.yaml`
- `k run test --image=busybox --restart=Never -- sleep 3600 $do > pod.yaml`
- `k create ns practice`
- `k autoscale deployment web --cpu-percent=70 --min=1 --max=5`

## Troubleshoot in fast order

1. Check API-level symptoms: `k get events -A --sort-by=.lastTimestamp`
2. Check kubelet state: `systemctl status kubelet`, `journalctl -u kubelet -xe`
3. Check container runtime: `crictl ps -a`, `crictl logs <container-id>`
4. Check static manifests and host files: `/etc/kubernetes/manifests/*.yaml`

## Fast lookup one-liners

- Pending Pods: `k get pods -A --field-selector=status.phase=Pending`
- Node pressure taints: `k get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.taints}{"\n"}{end}'`
- Pods by QoS: `k get pods -A -o custom-columns=NS:.metadata.namespace,NAME:.metadata.name,QOS:.status.qosClass`
- Failed probes: `k describe pod <pod> | sed -n '/Events:/,$p'`
- RBAC test: `k auth can-i get pods --as=system:serviceaccount:<ns>:<sa> -n <ns>`
