#!/bin/bash

mkdir -p ssl

#Base Certificate Config
cat << EOF > ssl/req.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = docker.localhost
EOF

# CA Chain
openssl genrsa -out ssl/ca.key 2048
openssl req -x509 -new -nodes -key ssl/ca.key -days 10 -out ssl/ca.crt -subj "/CN=traefik-ca"

# Certificate examples
# Client Cert
openssl genrsa -out ssl/client.key 2048
openssl req -new -key ssl/client.key -out ssl/client.csr -subj "/CN=foo.docker.localhost" -config ssl/req.cnf
openssl x509 -req -in ssl/client.csr -CA ssl/ca.crt -CAkey ssl/ca.key -CAcreateserial -out ssl/client.crt -days 10 -extensions v3_req -extfile ssl/req.cnf

# Server Cert
openssl genrsa -out ssl/server.key 2048
openssl req -new -key ssl/server.key -out ssl/server.csr -subj "/CN=bar.docker.localhost" -config ssl/req.cnf
openssl x509 -req -in ssl/server.csr -CA ssl/ca.crt -CAkey ssl/ca.key -CAcreateserial -out ssl/server.crt -days 10 -extensions v3_req -extfile ssl/req.cnf