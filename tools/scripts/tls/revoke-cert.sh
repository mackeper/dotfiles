#!/usr/bin/env bash
set -euo pipefail

# Load .env
set -a
source "$(dirname "$0")/.env"
set +a

# Required variables
: "${PKI_DIR:?PKI_DIR is not set. Check your .env file}"
: "${$1:?$1 is not set. Usage: $0 <cert-name>}"
: "${CA_CERT_NAME:?CA_CERT_NAME is not set. Check your .env file}"

NAME=$1
PKI_DIR="$HOME/pki"

cd $PKI_DIR

openssl ca -config openssl.cnf \
  -revoke certs/$NAME.cert.pem

openssl ca -config openssl.cnf \
  -gencrl -out crl/$CA_CERT_NAME.crl.pem

echo "Certificate revoked and CRL updated"
