# Generate certificates

Run `gen-certs.sh` to generate a CA and a set of certificates for client and server.
They will be stored under the `ssl/` folder.

# Create k8s secrets

Create Kubernetes secrets to hold CA and certs

```bash
# CA
kubectl create secret generic mtls-ca --from-file=tls.ca=ssl/ca.crt -n apps
# Backend cert
kubectl create secret generic whoami-cert --from-file=tls.crt=ssl/server.crt --from-file=tls.key=ssl/server.key -n apps
```

# Deploy the stacks

```bash
kubectl create namespace apps
kubectl apply -n apps -f whoami.yaml
kubectl apply -n apps -f whoami-tls.yaml
```