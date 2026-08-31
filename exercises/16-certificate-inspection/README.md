# Exercise 16: Inspect certificate details

## Task

Extract and decode `client-certificate-data` from `/tmp/cka-prep-labs/16-kubeconfig.yaml`, then inspect subject, issuer, dates, and EKU with `openssl x509`.

## Procedure

1. Run `make seed EXERCISE=16`.
2. Extract and decode certificate data.
3. Write output to `/tmp/cka-prep-labs/16-cert-report.txt`.
4. Run `make verify EXERCISE=16`.

## Gotchas

- `kubeadm certs check-expiration` reports expiration only, not EKU.
- Split PEM chains with `csplit` before individual inspection when needed.
