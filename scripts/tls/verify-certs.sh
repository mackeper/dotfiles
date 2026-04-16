#!/usr/bin/env bash
set -euo pipefail

# Load .env
set -a
source "$(dirname "$0")/.env"
set +a

# Required variables
: "${PKI_DIR:?PKI_DIR is not set. Check your .env file}"

: "${CERT_FILE_EXTENSION:?CERT_FILE_EXTENSION is not set. Check your .env file}"

: "${CA_CERT_PATH:?CA_CERT_PATH is not set. Check your .env file}"
: "${CA_CRL_PATH:?CA_CRL_PATH is not set. Check your .env file}"

: "${INTERMEDIATE_CERT_PATH:?INTERMEDIATE_CERT_PATH is not set. Check your .env file}"
: "${INTERMEDIATE_CRL_PATH:?INTERMEDIATE_CRL_PATH is not set. Check your .env file}"

: "${CHAIN_CERT_PATH:?CHAIN_CERT_PATH is not set. Check your .env file}"

CHAIN_CERT_PATH=$PKI_DIR/$CHAIN_CERT_PATH
CRL_PATH=$PKI_DIR/$INTERMEDIATE_CRL_PATH

TMP=tmp-verify-certs
mkdir -p "$TMP"
trap "rm -rf $TMP" EXIT

[[ -f "$CHAIN_CERT_PATH" ]] || { echo "Chain CA certificate not found at $CHAIN_CERT_PATH"; exit 1; }
[[ -f "$CRL_PATH" ]] || { echo "CRL not found at $CRL_PATH"; exit 1; }

ls $PKI_DIR/certs/*$CERT_FILE_EXTENSION 2>/dev/null || { echo "No certificates found in $PKI_DIR/certs with extension .$CERT_FILE_EXTENSION"; exit 1; }

for CERT in $PKI_DIR/certs/*$CERT_FILE_EXTENSION; do
    [ -f "$CERT" ] || continue
    echo "Verifying $CERT against Chain CA certificate $CHAIN_CERT_PATH"
    echo "with CRL $CRL_PATH"
    openssl verify -crl_check \
      -CAfile $CHAIN_CERT_PATH \
      -CRLfile $CRL_PATH \
      "$CERT"

    AIA=$(openssl x509 -in "$CERT" -noout -text | grep -oP 'CA Issuers - URI:\K.*')
    CDP=$(openssl x509 -in "$CERT" -noout -text | grep -oP 'URI:\K[^,]*' | head -1)

    echo "Checking AIA URL: $AIA"
    echo "Checking CDP URL: $CDP"

    curl -s -o $TMP/intermediate.pem "$AIA"
    curl -s -o $TMP/crl.pem "$CDP"

    # Follow the chain - get root from intermediate's AIA
    ROOT_AIA=$(openssl x509 -in "$TMP/intermediate.pem" -noout -text | grep -oP 'CA Issuers - URI:\K.*')
    echo "Checking Root AIA URL: $ROOT_AIA"
    curl -sf "$ROOT_AIA" -o "$TMP/root.pem"

    # Build full chain
    cat "$TMP/intermediate.pem" "$TMP/root.pem" > "$TMP/chain.pem"

    echo "Verifying $CERT against downloaded Chain CA certificate and CRL"
    openssl verify -crl_check \
      -CAfile $TMP/chain.pem \
      -CRLfile $TMP/crl.pem \
      "$CERT"

done
