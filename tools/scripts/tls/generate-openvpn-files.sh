#!/usr/bin/env bash

# Diffie-Hellman parameters are used in various cryptographic protocols to provide secure key exchange.
#
# It is not a part of the PKI, but it is a common component in many secure communication setups, such as TLS/SSL.

set -euo pipefail

# Load .env
set -a
source "$(dirname "$0")/.env"
set +a

# Required variables
: "${PKI_DIR:?PKI_DIR is not set. Check your .env file}"
: "${OPENVPN_DIR:?PKI_DIR is not set. Check your .env file}"
: "${ENCRYPTION_SIZE:?ENCRYPTION_SIZE is not set. Check your .env file}"
: "${OPENVPN_SERVER_URL:?OPENVPN_SERVER_URL is not set. Check your .env file}"

: "${KEY_FILE_EXTENSION:?KEY_FILE_EXTENSION is not set. Check your .env file}"
: "${CA_FILE_EXTENSION:?CA_FILE_EXTENSION is not set. Check your .env file}"
: "${CRL_FILE_EXTENSION:?CRL_FILE_EXTENSION is not set. Check your .env file}"
: "${CSR_FILE_EXTENSION:?CSR_FILE_EXTENSION is not set. Check your .env file}"
: "${CERT_FILE_EXTENSION:?CERT_FILE_EXTENSION is not set. Check your .env file}"

: "${CHAIN_CERT_NAME:?CHAIN_CERT_NAME is not set. Check your .env file}"
: "${CHAIN_CERT_PATH:?CHAIN_CERT_PATH is not set. Check your .env file}"
: "${CHAIN_FILE_EXTENSION:?CHAIN_FILE_EXTENSION is not set. Check your .env file}"

: "${CA_CRL_PATH:?CA_CRL_PATH is not set. Check your .env file}"
: "${INTERMEDIATE_CRL_PATH:?INTERMEDIATE_CRL_PATH is not set. Check your .env file}"

[ "$#" -ne 3 ] && { echo "Usage: $0 <client name> <server name> <server_url>"; exit 1; }

CLIENT_NAME="$1"
SERVER_NAME="$2"
SERVER_URL="$3"

CHAIN_CERT_PKI_PATH="$PKI_DIR/$CHAIN_CERT_PATH"
CA_CRL_PKI_PATH="$PKI_DIR/$CA_CRL_PATH"
INTERMEDIATE_CRL_PKI_PATH="$PKI_DIR/$INTERMEDIATE_CRL_PATH"
CLIENT_CERT_PATH="$PKI_DIR/certs/$CLIENT_NAME$CERT_FILE_EXTENSION"
CLIENT_KEY_PATH="$PKI_DIR/private/$CLIENT_NAME$KEY_FILE_EXTENSION"
SERVER_CERT_PATH="$PKI_DIR/certs/$SERVER_NAME$CERT_FILE_EXTENSION"
SERVER_KEY_PATH="$PKI_DIR/private/$SERVER_NAME$KEY_FILE_EXTENSION"

COPIED_CHAIN_CERT_PATH="$OPENVPN_DIR/$CHAIN_CERT_NAME$CHAIN_FILE_EXTENSION"
COPIED_SERVER_CERT_PATH="$OPENVPN_DIR/$SERVER_NAME$CERT_FILE_EXTENSION"
COPIED_SERVER_KEY_PATH="$OPENVPN_DIR/$SERVER_NAME$KEY_FILE_EXTENSION"
COPIED_CRL_PATH="$OPENVPN_DIR/ca_and_intermediate$CRL_FILE_EXTENSION"

DH_ENCRYPTION_SIZE=2048
TA_KEY_PATH="$OPENVPN_DIR/ta.key"
DH_PARAM_PATH="$OPENVPN_DIR/dh$DH_ENCRYPTION_SIZE.pem"
OVPN_PATH="$OPENVPN_DIR/$CLIENT_NAME.ovpn"

[[ -f "$CHAIN_CERT_PKI_PATH" ]] || { echo "Chain CA certificate not found at $CHAIN_CERT_PKI_PATH"; exit 1; }
[[ -f "$CLIENT_CERT_PATH" ]] || { echo "Client certificate not found at $CLIENT_CERT_PATH"; exit 1; }
[[ -f "$CLIENT_KEY_PATH" ]] || { echo "Client key not found at $CLIENT_KEY_PATH"; exit 1; }
[[ -f "$CA_CRL_PKI_PATH" ]] || { echo "CA CRL file not found at $CA_CRL_PKI_PATH"; exit 1; }
[[ -f "$INTERMEDIATE_CRL_PKI_PATH" ]] || { echo "Intermediate CRL file not found at $INTERMEDIATE_CRL_PKI_PATH"; exit 1; }

if ! openssl x509 -in "$CLIENT_CERT_PATH" -noout -text | grep -q "TLS Web Client Authentication" || \
   ! openssl x509 -in "$CLIENT_CERT_PATH" -noout -text | grep -q "CA:FALSE"; then
    echo "Client certificate does not have the correct EKU or is not marked as a non-CA. ($CLIENT_CERT_PATH)"
    exit 1
fi

if ! openssl x509 -in "$SERVER_CERT_PATH" -noout -text | grep -q "TLS Web Server Authentication" || \
   ! openssl x509 -in "$SERVER_CERT_PATH" -noout -text | grep -q "CA:FALSE"; then
    echo "Server certificate does not have the correct Extended Key Usage (EKU) for TLS Web Server Authentication or is not marked as a non-CA. Please check your server certificate. ($SERVER_CERT_PATH)"
    exit 1
fi

mkdir -p $OPENVPN_DIR

# ---------------------
# Copy necessary files to OpenVPN directory
# ---------------------
if [ ! -f "$COPIED_SERVER_CERT_PATH" ]; then
    echo "Copy server certificate..."
    cp $SERVER_CERT_PATH $COPIED_SERVER_CERT_PATH
fi

if [ ! -f "$COPIED_SERVER_KEY_PATH" ]; then
    echo "Copy server key..."
    cp $SERVER_KEY_PATH $COPIED_SERVER_KEY_PATH
fi

if [ ! -f "$COPIED_CHAIN_CERT_PATH" ]; then
    echo "Copy chain CA certificate..."
    cp $CHAIN_CERT_PKI_PATH $COPIED_CHAIN_CERT_PATH
fi

if [ ! -f "$COPIED_CRL_PATH" ]; then
    echo "Copy CRL files..."
    cat $CA_CRL_PKI_PATH $INTERMEDIATE_CRL_PKI_PATH > $COPIED_CRL_PATH
fi

# ---------------------
# Generate Diffie-Hellman parameters and TLS-Auth key if they don't exist
# ---------------------
if [[ -f "$DH_PARAM_PATH" ]]; then
    echo "Diffie-Hellman parameters already exist at $DH_PARAM_PATH. Skipping generation."
else
    echo "Generating Diffie-Hellman parameters with size $DH_ENCRYPTION_SIZE bits... ($OPENVPN_DIR/dh$DH_ENCRYPTION_SIZE.pem)"
    openssl dhparam -out $DH_PARAM_PATH $DH_ENCRYPTION_SIZE
fi

if [[ -f "$TA_KEY_PATH" ]]; then
    echo "TLS-Auth key already exists at $TA_KEY_PATH. Skipping generation."
else
    echo "Generating TLS-Auth key (ta.key) with size 256 bytes... ($OPENVPN_DIR/ta.key)"
    (
        echo "#"
        echo "# 2048 bit OpenVPN static key"
        echo "#"
        echo "-----BEGIN OpenVPN Static key V1-----"
        openssl rand -hex 256 | fold -w 32
        echo "-----END OpenVPN Static key V1-----"
    ) > $TA_KEY_PATH
fi

# --------------------
# ovpn file generation
# --------------------
if [[ -f "$OVPN_PATH" ]]; then
    echo "Client configuration file already exists at $OVPN_PATH. Skipping generation."
    exit 0
fi
echo "Generating client configuration file... ($OPENVPN_DIR/$CLIENT_NAME.ovpn)"
echo "Using chain certificate: $CHAIN_CERT_PKI_PATH"
cat > $OVPN_PATH <<EOL
client
dev tun
proto udp
remote $SERVER_URL 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
auth SHA256
verb 3
key-direction 1
<ca>
$(cat $CHAIN_CERT_PKI_PATH)
</ca>
<cert>
$(cat $CLIENT_CERT_PATH)
</cert>
<key>
$(cat $CLIENT_KEY_PATH)
</key>
<tls-auth>
$(cat $TA_KEY_PATH)
</tls-auth>
EOL
