#!/usr/bin/env bash
set -euo pipefail

# Load .env
set -a
source "$(dirname "$0")/.env"
set +a

NAME=$1

# Required variables
: "${PKI_DIR:?PKI_DIR is not set. Check your .env file}"
: "${NAME:?NAME is not set. Usage: $0 <name>}"
: "${ENCRYPTION_SIZE:?ENCRYPTION_SIZE is not set. Check your .env file}"
: "${CHAIN_CERT_NAME:?CHAIN_CERT_NAME is not set. Check your .env file}"

cd $PKI_DIR

# Generate a random password for the PFX file
PFX_PASSWORD=$(openssl rand -base64 20)

[ -f certs/$NAME.cert.pem ] || { echo "Certificate not found: $PKI_DIR/certs/$NAME.cert.pem"; exit 1; }
[ -f private/$NAME.key.pem ] || { echo "Private key not found: $PKI_DIR/private/$NAME.key.pem"; exit 1; }
[ -f ca/$CHAIN_CERT_NAME.cert.pem ] || { echo "Chain certificate not found: $PKI_DIR/ca/$CHAIN_CERT_NAME.cert.pem"; exit 1; }

# Create PFX/P12 file (includes cert + private key)
openssl pkcs12 -export \
  -out certs/$NAME.pfx \
  -inkey private/$NAME.key.pem \
  -in certs/$NAME.cert.pem \
  -certfile ca/$CHAIN_CERT_NAME.cert.pem \
  -password pass:$PFX_PASSWORD

# Save password to file
echo "$PFX_PASSWORD" > certs/$NAME.pfx.password.txt
chmod 600 certs/$NAME.pfx.password.txt

echo ""
echo "========================================"
echo "PFX created: certs/$NAME.pfx"
echo "Password: $PFX_PASSWORD"
echo "Password saved to: certs/$NAME.pfx.password.txt"
echo "========================================"
echo ""
