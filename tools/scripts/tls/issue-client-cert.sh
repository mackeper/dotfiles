#!/usr/bin/env bash
set -euo pipefail

# Load .env
set -a
source "$(dirname "$0")/.env"
set +a

[ $# -ne 1 ] && echo "Usage: $0 <name>" && exit 1
NAME=$1

# Required variables
: "${PKI_DIR:?PKI_DIR is not set. Check your .env file}"
: "${NAME:?NAME is not set. Usage: $0 <name>}"
: "${ENCRYPTION_SIZE:?ENCRYPTION_SIZE is not set. Check your .env file}"
: "${KEY_FILE_EXTENSION:?KEY_FILE_EXTENSION is not set. Check your .env file}"
: "${CSR_FILE_EXTENSION:?CSR_FILE_EXTENSION is not set. Check your .env file}"
: "${CERT_FILE_EXTENSION:?CERT_FILE_EXTENSION is not set. Check your .env file}"


NEW_KEY_PATH="private/$NAME$KEY_FILE_EXTENSION"
if [ -f "$NEW_KEY_PATH" ]; then
  echo "Error: Key file $NEW_KEY_PATH already exists. Aborting to prevent overwriting."
  exit 1
fi
NEW_CSR_PATH="csr/$NAME$CSR_FILE_EXTENSION"
if [ -f "$NEW_CSR_PATH" ]; then
  echo "Error: CSR file $NEW_CSR_PATH already exists. Aborting to prevent overwriting."
  exit 1
fi
NEW_CERT_PATH="certs/$NAME$CERT_FILE_EXTENSION"
if [ -f "$NEW_CERT_PATH" ]; then
  echo "Error: Certificate file $NEW_CERT_PATH already exists. Aborting to prevent overwriting."
  exit 1
fi

cd $PKI_DIR

openssl genrsa -out $NEW_KEY_PATH $ENCRYPTION_SIZE

openssl req -new \
  -key $NEW_KEY_PATH \
  -subj "/CN=$NAME" \
  -out $NEW_CSR_PATH

openssl ca -config openssl.cnf \
  -extensions v3_client \
  -days 1825 \
  -notext -md sha256 \
  -in $NEW_CSR_PATH \
  -out $NEW_CERT_PATH \
  -batch

echo "Client certificate issued:"
echo "$NEW_CERT_PATH"
