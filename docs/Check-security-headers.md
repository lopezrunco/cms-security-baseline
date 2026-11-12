1. Go to the utils folder and run the script "check_security_headers.sh".

2. If the headers are not set you should get something like this:

```sh
[MISSING] Content-Security-Policy-Report-Only
[MISSING] X-Frame-Options
[MISSING] Strict-transport-Security
[MISSING] Permissions-Policy
```

3. Paste this code in the file `.htaccess`. It's a baseline for most Wordpress sites, but it might require some adjustment depending of the output of the script.

```sh
# Security Headers.
<IfModule mod_headers.c>
    # 1. Clickjacking protection
    Header always set X-Frame-Options "SAMEORIGIN"

    # 2. HSTS: 1 year (only after confirming HTTPS works on the whole site)
    Header always set Strict-Transport-Security "max-age=31536000"

    # 3. Disable browser features the site doesn't use
    #    (remove payment=() on shops, geolocation=() on sites with maps/locators)
    Header always set Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()"

    # 4. CSP in Report-Only mode: reports problems, blocks nothing
    Header always set Content-Security-Policy-Report-Only "default-src 'self' https:; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' https:; img-src 'self' data: https:; font-src 'self' data: https:; frame-ancestors 'self'"
</IfModule>
```

4. Running the script again and you should a result like this:

```sh
[OK]      content-security-policy-report-only: default-src 'self' https:; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' https:; img-src 'self' data: https:; font-src 'self' data: https:; frame-ancestors 'self'
[WARN]    No report-uri/report-to: violations won't be sent anywhere.
[OK]      x-frame-options: SAMEORIGIN
[OK]      strict-transport-security: max-age=300
[WARN]    max-age is below 1 year (31536000).
[OK]      permissions-policy: camera=(), microphone=(), geolocation=(), payment=()
```