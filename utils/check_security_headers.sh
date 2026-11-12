#!/bin/bash

read -rp "Website URL: " URL # r stops backlashes to be treated as escape characters. p shows the prompt text.
[[ $URL =~ ^https?:// ]] || URL="https://$URL" # Ensure the use of HTTPS.

# Use a normal GET (some servers answer HEAD differently), follow redirects,
# discard the body, and print the headers of every response in the chain.
# -s: silent mode.
# L: follow redirects.
# -A: set a browser-like user-agent.
# -o: throw away the page body, because only headers matter.
# -D: dump the response headers to a standard output instead of a file.
# tr -d '\r': delete carriage returns.
ALL=$(curl -sL -A "Mozilla/5.0" -o /dev/null -D - "$URL" | tr -d '\r')

# Keep only the LAST response (the final page, after redirects).
FINAL=$(echo "$ALL" | awk 'BEGIN{RS=""} {last=$0} END{print last}')

# Returns the header's line.
get() { echo "$FINAL" | grep -i "^$1:" | head -1; }

# Status functions.
ok()   { echo -e "\e[32m[OK]\e[0m      $1"; }
warn() { echo -e "\e[33m[WARN]\e[0m    $1"; }
miss() { echo -e "\e[31m[MISSING]\e[0m $1"; }

echo -e "\nChecking: $URL\n"

# 1. CSP Report-Only -------------------------------------------------------------

CSP_RO=$(get "content-security-policy-report-only")
CSP=$(get "content-security-policy")

if [ -n "$CSP_RO" ]; then # Run if CSP_PRO is not empty...
    ok "$CSP_RO"
    # Check wether it contains report-uri or report-to
    echo "$CSP_RO" | grep -qiE "report-uri|report-to" \
        || warn "No report-uri/report-to: violations won't be sent anywhere."
elif [ -n "$CSP" ]; then # Run if there's no report-only header but there's an enforcing one.
    warn "Enforcing CSP found (not Report-Only): $CSP"
else
    miss "Content-Security-Policy-Report-Only"
fi

# 2. X-Frame-Options -------------------------------------------------------------

XFO=$(get "x-frame-options")
[ -n "$XFO" ] && ok "$XFO" || miss "X-Frame-Options"

# 3. HSTS ------------------------------------------------------------------------

HSTS=$(get "strict-transport-security")

if [ -n "$HSTS" ]; then
    ok "$HSTS"
    AGE=$(echo "$HSTS" | grep -oiP 'max-age=\K[0-9]+') # Extracts the max-age number.
    [ "${AGE:-0}" -lt 31536000 ] && warn "max-age is below 1 year (31536000)."
else
    miss "Strict-transport-Security"
fi

# 4. Permissions-Policy ------------------------------------------------------------

PP=$(get "permissions-policy")
[ -n "$PP" ] && ok "$PP" || miss "Permissions-Policy"

echo # Print a final line so the output isn't glued to the next prompt.
