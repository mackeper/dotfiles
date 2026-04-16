#!/usr/bin/env bash
# Initializes a new PKI with a Root CA and an Intermediate CA.
#
# Usage: ./init-pki.sh
#
# The root CA key should be kept offline and secure.
# The intermediate CA can be used for signing server and client certificates.
# If the intermediate CA is compromised, you can revoke it and
# generate a new one without affecting the root CA.


set -euo pipefail

# Load .env
set -a
source "$(dirname "$0")/.env"
set +a

# Required variables
: "${PKI_DIR:?PKI_DIR is not set. Check your .env file}"
: "${DOMAIN:?DOMAIN is not set. Check your .env file}"
: "${ENCRYPTION_SIZE:?ENCRYPTION_SIZE is not set. Check your .env file}"

: "${KEY_FILE_EXTENSION:?KEY_FILE_EXTENSION is not set. Check your .env file}"
: "${CA_FILE_EXTENSION:?CA_FILE_EXTENSION is not set. Check your .env file}"
: "${CRL_FILE_EXTENSION:?CRL_FILE_EXTENSION is not set. Check your .env file}"
: "${CSR_FILE_EXTENSION:?CSR_FILE_EXTENSION is not set. Check your .env file}"

: "${CA_NAME:?CA_NAME is not set. Check your .env file}"
: "${CA_CERT_NAME:?CA_CERT_NAME is not set. Check your .env file}"
: "${CA_KEY_PATH:?CA_KEY_PATH is not set. Check your .env file}"
: "${CA_CERT_PATH:?CA_CERT_PATH is not set. Check your .env file}"
: "${CA_CRL_PATH:?CA_CRL_PATH is not set. Check your .env file}"

: "${INTERMEDIATE_NAME:?INTERMEDIATE_NAME is not set. Check your .env file}"
: "${INTERMEDIATE_CERT_NAME:?INTERMEDIATE_CERT_NAME is not set. Check your .env file}"
: "${INTERMEDIATE_KEY_PATH:?INTERMEDIATE_KEY_PATH is not set. Check your .env file}"
: "${INTERMEDIATE_CERT_PATH:?INTERMEDIATE_CERT_PATH is not set. Check your .env file}"
: "${INTERMEDIATE_CSR_PATH:?INTERMEDIATE_CSR_PATH is not set. Check your .env file}"
: "${INTERMEDIATE_CRL_PATH:?INTERMEDIATE_CRL_PATH is not set. Check your .env file}"

: "${CHAIN_CERT_PATH:?CHAIN_CERT_PATH is not set. Check your .env file}"

echo "Creating PKI at $PKI_DIR"
mkdir -p $PKI_DIR
cd $PKI_DIR

# Folder structure
mkdir -p certs crl newcerts private csr ca
chmod 700 private

touch index.txt
echo 1000 > serial
echo 1000 > crlnumber

# -----------------------------
# OpenSSL configuration
# -----------------------------
cat > openssl.cnf <<EOF
[ ca ]
default_ca = CA_default

[ CA_default ]
dir               = $PKI_DIR
certs             = \$dir/certs
ca                = \$dir/ca
crl_dir           = \$dir/crl
new_certs_dir     = \$dir/newcerts
database          = \$dir/index.txt
serial            = \$dir/serial
crlnumber         = \$dir/crlnumber

private_key       = \$dir/$INTERMEDIATE_KEY_PATH
certificate       = \$dir/$INTERMEDIATE_CERT_PATH
crl               = \$dir/$INTERMEDIATE_CRL_PATH

default_md        = sha256
default_days      = 7300
default_crl_days  = 30

policy            = policy_loose
x509_extensions   = v3_ca

[ policy_loose ]
commonName              = supplied

[ req ]
default_bits        = 4096
distinguished_name  = req_dn
x509_extensions     = v3_ca
prompt              = no

[ req_dn ]
CN = $CA_NAME

[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ v3_server ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
crlDistributionPoints = URI:$DOMAIN/$INTERMEDIATE_CRL_PATH
authorityInfoAccess = caIssuers;URI:$DOMAIN/$INTERMEDIATE_CERT_PATH

[ v3_client ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = clientAuth
crlDistributionPoints = URI:$DOMAIN/$INTERMEDIATE_CRL_PATH
authorityInfoAccess = caIssuers;URI:$DOMAIN/$INTERMEDIATE_CERT_PATH

[ v3_intermediate_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
crlDistributionPoints = URI:$DOMAIN/$CA_CRL_PATH
authorityInfoAccess = caIssuers;URI:$DOMAIN/$CA_CERT_PATH
EOF

# -----------------------------
# ROOT CA
# -----------------------------
echo "Generating Root CA key: '$PKI_DIR/$CA_KEY_PATH'"
openssl genrsa -out $CA_KEY_PATH $ENCRYPTION_SIZE
chmod 400 $CA_KEY_PATH

echo "Generating Root CA certificate: '$PKI_DIR/$CA_CERT_PATH'"
openssl req -config openssl.cnf \
    -key $CA_KEY_PATH \
    -new -x509 -days 7300 -sha256 -extensions v3_ca \
    -out $CA_CERT_PATH
chmod 444 $CA_CERT_PATH

echo "Generating initial CRL: '$PKI_DIR/$CA_CRL_PATH'"
openssl ca -config openssl.cnf \
    -gencrl \
    -keyfile $CA_KEY_PATH \
    -cert $CA_CERT_PATH \
    -out $CA_CRL_PATH

# -----------------------------
# INTERMEDIATE CA
# -----------------------------
echo "Generating Intermediate CA key: '$PKI_DIR/$INTERMEDIATE_KEY_PATH'"
openssl genrsa -out $INTERMEDIATE_KEY_PATH $ENCRYPTION_SIZE
chmod 400 $INTERMEDIATE_KEY_PATH

echo "Generating Intermediate CA CSR: '$PKI_DIR/$INTERMEDIATE_CSR_PATH'"
openssl req -config openssl.cnf -new -sha256 \
    -subj "/CN=$INTERMEDIATE_NAME" \
    -key $INTERMEDIATE_KEY_PATH \
    -out $INTERMEDIATE_CSR_PATH

echo "Signing Intermediate CA certificate with Root CA: '$PKI_DIR/$INTERMEDIATE_CERT_PATH'"
openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
    -days 3650 -notext -md sha256 \
    -keyfile $CA_KEY_PATH \
    -cert $CA_CERT_PATH \
    -in $INTERMEDIATE_CSR_PATH \
    -out $INTERMEDIATE_CERT_PATH
chmod 444 $INTERMEDIATE_CERT_PATH

echo "Verifying intermediate certificate: '$PKI_DIR/$INTERMEDIATE_CERT_PATH'"
openssl x509 -noout -text -in $INTERMEDIATE_CERT_PATH

echo "Verifying certificate chain: '$PKI_DIR/$INTERMEDIATE_CERT_PATH' signed by '$PKI_DIR/$CA_CERT_PATH'"
openssl verify -CAfile $CA_CERT_PATH $INTERMEDIATE_CERT_PATH

echo "Creating certificate chain file: '$PKI_DIR/$CHAIN_CERT_PATH'"
cat $INTERMEDIATE_CERT_PATH $CA_CERT_PATH > $CHAIN_CERT_PATH

echo "Generating initial CRL for intermediate: '$PKI_DIR/$INTERMEDIATE_CRL_PATH'"
openssl ca -config openssl.cnf -gencrl -out $INTERMEDIATE_CRL_PATH

echo "PKI initialized."
