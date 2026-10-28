#!/bin/bash
# Connects to Ivanti VPN via the local daemon.
# Works over SSH — no sudo or GUI session access needed.
#
# Usage: ./auto-connect.sh <TOTP_CODE>

set -euo pipefail

DAEMON_URL="http://127.0.0.1:7492"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <TOTP_CODE>" >&2
    exit 1
fi

curl -sf "${DAEMON_URL}/connect?totp=$1"
