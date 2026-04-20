#!/usr/bin/env bash
set -euo pipefail

openssl x509 -text -noout -in $1
