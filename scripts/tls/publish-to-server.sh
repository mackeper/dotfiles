#!/usr/bin/env bash
set -euo pipefail

# Load .env
set -a
source "$(dirname "$0")/.env"
set +a

# Required variables
: "${PKI_DIR:?PKI_DIR is not set. Check your .env file}"
: "${SERVER_NAME:?SERVER_NAME is not set. Check your .env file}"
: "${WEB_PATH:?WEB_PATH is not set. Check your .env file}"

: "${CA_CERT_PATH:?CA_CERT_PATH is not set. Check your .env file}"
: "${CA_CRL_PATH:?CA_CRL_PATH is not set. Check your .env file}"

: "${INTERMEDIATE_CERT_PATH:?INTERMEDIATE_CERT_PATH is not set. Check your .env file}"
: "${INTERMEDIATE_CRL_PATH:?INTERMEDIATE_CRL_PATH is not set. Check your .env file}"

: "${CHAIN_CERT_PATH:?CHAIN_CERT_PATH is not set. Check your .env file}"

TMP="/tmp"

cd $PKI_DIR

paths_to_copy=(
    "$CA_CERT_PATH"
    "$INTERMEDIATE_CERT_PATH"
    "$CHAIN_CERT_PATH"
    "$CA_CRL_PATH"
    "$INTERMEDIATE_CRL_PATH"
)

echo "Publishing certificates and CRLs to the server..."

echo "Cleaning up old certificates and CRLs on the server..."
ssh $SERVER_NAME "sudo rm -f $WEB_PATH/ca/*.pem $WEB_PATH/crl/*.pem"

echo "Creating directories on the server..."
ssh $SERVER_NAME "sudo mkdir -p $WEB_PATH/ca $WEB_PATH/crl"

echo "Copying ROOT CA, INTERMEDIATE, chain, and CRL to the server..."
for filepath in "${paths_to_copy[@]}"; do
    if [[ -f "$filepath" ]]; then
        echo $filepath
        echo "  Copying $filepath to $SERVER_NAME:$TMP/$(dirname $filepath)/$(basename $filepath)"
        echo "  scp $filepath $SERVER_NAME:$TMP/$(basename $filepath)"
        scp "$filepath" "$SERVER_NAME:$TMP/$(basename $filepath)"
        echo "  Moving $SERVER_NAME:$TMP/$(basename $filepath) to $SERVER_NAME:$WEB_PATH/$(dirname $filepath)/$(basename $filepath)"
        ssh $SERVER_NAME "sudo mv $TMP/$(basename $filepath) $WEB_PATH/$(dirname $filepath)/$(basename $filepath)"
    else
        echo "Warning: File $filepath does not exist and will be skipped."
    fi
done
