#!/bin/bash

clear
echo "=================================================="
echo "      VERIFY CSP ENFORCEMENT MODE                 "
echo "=================================================="
read -p "Type the URL of the website to verify: " URL

# Ensure the use of HTTPS protocol.
if [[ ! $URL =~ ^https?:// ]]; then
    URL="https://$URL"
fi

echo -e "\nConnecting to $URL...\n"

# Obtain headers forcing browser User Agent and following redirections.
HEADERS=$(curl -sIL -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$URL")

# Search for CSP directives.
CSP_ACTIVE=$(echo "$HEADERS" | grep -i "^content-security-policy:")
CSP_REPORT=$(echo "$HEADERS" | grep -i "^content-security-policy-report-only:")

# Diagnóstico
if [ -n "$CSP_ACTIVE" ]; then
    echo -e " \033[0;32m[SUCCESS] The CSP is on Enforcement-Mode (Active mode).\033[0m"
    echo -e "--------------------------------------------------"
    echo "$CSP_ACTIVE" | tr -d '\r'
    echo -e "--------------------------------------------------"
elif [ -n "$CSP_REPORT" ]; then
    echo -e " \033[0;33m[ALERT] The politics still on 'Report-Only'. The browser won't block anything.\033[0m"
    echo -e "--------------------------------------------------"
    echo "$CSP_REPORT" | tr -d '\r'
    echo -e "--------------------------------------------------"
else
    echo -e " \033[0;31m[ERROR] Couldn't find any Content-Security-Policy header on this site.\033[0m"
fi
echo "=================================================="
