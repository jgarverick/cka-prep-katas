#!/usr/bin/env bash
set -euo pipefail

ns="project-r500"

kubectl delete ns "$ns" --ignore-not-found
kubectl create ns "$ns"

cat <<'MANIFEST' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: desktop
  namespace: project-r500
spec:
  replicas: 1
  selector:
    matchLabels:
      app: desktop
  template:
    metadata:
      labels:
        app: desktop
    spec:
      containers:
        - name: app
          image: hashicorp/http-echo:1.0.0
          args: ["-listen=:8080", "-text=desktop"]
          ports:
            - containerPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mobile
  namespace: project-r500
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mobile
  template:
    metadata:
      labels:
        app: mobile
    spec:
      containers:
        - name: app
          image: hashicorp/http-echo:1.0.0
          args: ["-listen=:8080", "-text=mobile"]
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: desktop
  namespace: project-r500
spec:
  selector:
    app: desktop
  ports:
    - port: 80
      targetPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: mobile
  namespace: project-r500
spec:
  selector:
    app: mobile
  ports:
    - port: 80
      targetPort: 8080
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: main
  namespace: project-r500
spec:
  gatewayClassName: nginx
  listeners:
    - name: http
      protocol: HTTP
      port: 80
      hostname: r500.gateway
      allowedRoutes:
        namespaces:
          from: Same
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: legacy-routing
  namespace: project-r500
spec:
  ingressClassName: nginx
  rules:
    - host: r500.gateway
      http:
        paths:
          - path: /desktop
            pathType: Prefix
            backend:
              service:
                name: desktop
                port:
                  number: 80
          - path: /mobile
            pathType: Prefix
            backend:
              service:
                name: mobile
                port:
                  number: 80
MANIFEST

kubectl -n "$ns" rollout status deployment/desktop --timeout=180s
kubectl -n "$ns" rollout status deployment/mobile --timeout=180s

echo "Exercise 06 seeded in namespace $ns."
