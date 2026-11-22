# Website Security Checklist

**Stack:** cPanel - WordPress/Joomla
**Last updated:** 23-07-2026

---

## Phase 1: Hardening and basic security

### CMS core
- [ ] Remove sample content, sample pages, and test users.
- [ ] Delete unused themes and plugins.
- [ ] Change the default username ("admin").
- [ ] Enforce strong passwords on all accounts.
- [ ] Enable multi-factor authentication on administrator accounts.
- [ ] Move login pages (such as `wp-login` or `administrator`) to a custom URL (WPS Hide Login plugin).
- [ ] If not needed, disable `XML-RPC` in `.htaccess`. [See code](./docs/Disable-XML-RPC.php)
- [ ] Add security headers via `.htaccess` (CSP report-only, X-Frame-Options, HSTS, Permissions-Policy). [See guide](./docs/Check-security-headers.md)
- [ ] Set `wp-config.php` permissions to 640 via cPanel.
- [ ] Disable theme and plugin file editing from the admin dashboard. [See code](./docs/Disable-file-editing-WP-dashboard.php)
- [ ] Force SSL for administrators. [See code](./docs/Enable-forced-SSL-for-admin.php)
- [ ] Remove files such as `readme.html` and `license.txt` from the web root.
- [ ] Remove the CMS version from the generator meta tag. [See code](./docs/Remove-WP-version-from-meta-generator-tag.php)
- [ ] Enable debug logging to a file (never to the browser). [See code](./docs/Enable-debug-logging-to-file.php)
- [ ] Add a captcha to all public forms (Cloudflare Turnstile recommended).
- [ ] Verify that the salts in `wp-config.php` are unique (generate them at <https://api.wordpress.org/secret-key/1.1/salt/>).
- [ ] Create a child theme before customizing.
- [ ] Verify that the keys and salts in `wp-config.php` are rotated after any credential exposure incident.
- [ ] Audit all user accounts; remove legacy or test accounts with unrotated credentials.
- [ ] Verify that migration plugins (such as `All-in-One WP Migration`) are not installed in production. If they are, confirm that the backup directory is not publicly accessible.
- [ ] For e-commerce, check `WooCommerce` => `Site Health` and remediate any findings.
- [ ] Apply the principle of least privilege to user accounts:
    - Administrator: technical staff only
    - Shop manager: client/operations
    - Never share accounts between people
- [ ] Disable automatic updates for WordPress, themes, and plugins (they will be performed manually after staging). [See code](./docs/Disable-automatic-updates.php)

### Hosting / cPanel

- [ ] Enable an HTTPS certificate via cPanel if it is not enabled by default.
- [ ] Force HTTP => HTTPS redirection in `.htaccess`. [See code](./docs/Force-HTTP-HTTPS-redirection.php)
- [ ] Check that ModSecurity WAF is enabled in cPanel.
- [ ] Restrict directory listing (add the line `Options -Indexes` to `.htaccess`).
- [ ] Confirm that the PHP version is recent.
- [ ] Confirm that NO backup files exist in `public_html` (`.wpress`, `.tar.gz`, `.zip`, `.sql`). [See code](./docs/Check-backup-files.sh)
- [ ] Verify direct accessibility of backup directories by visiting their URLs in the browser.

---

## Phase 2: Theme and plugin audit

### Theme
- [ ] Confirm that the theme license is active and renewable. An expired license prevents updates and creates permanent security debt.
- [ ] Audit and remove demo content, sliders, sample pages, and sample products.
- [ ] Register the theme license to receive update notifications.
- [ ] Disable theme features that are not in use (page builders, unused headers).
- [ ] Confirm that the child theme is active before any customization.
- [ ] Audit plugins bundled inside the theme (e.g., `Slider Revolution` inside `Divi`) — they may have their own CVEs and may not update independently.
- [ ] For custom themes, find and remediate vulnerabilities in the code, either manually or with tools such as `semgrep`. [See basic semgrep guide](./docs/Semgrep-use.sh)

### Plugins
- [ ] Audit all installed plugins and remove those that are not needed.
- [ ] For each plugin: check `Wordfence Threat Intel` or `WPScan` for known CVEs in the installed version. [See guide](./docs/Run-WPScan-for-CVEs.md)
- [ ] Update all plugins to the latest version.
- [ ] Install `Wordfence`/`Imunify360`/`Akeeba Admin Tools` (WAF and login protection).
- [ ] Install `WP Activity Log` to audit activity.
- [ ] Install a caching plugin (`LiteSpeed Cache`) and configure it. [See guide](./docs/LiteSpeed-config.md)
- [ ] Install an image optimization plugin (Imagify or ShortPixel) (improves performance and reduces the attack surface against a DoS).

---

## Phase 3: Store configuration (WooCommerce/VirtueMart)

### Basic configuration
- [ ] Set the country and currency correctly.
- [ ] For catalog mode, configure it via [PHP](./docs/Configure-catalog-mode-via-Code-Snippets.php).
- [ ] Verify that the payment gateway (`Mercado Pago`, `Handy`, etc.) is up to date. Payment plugins are high-value targets and often patch vulnerabilities silently.
- [ ] Confirm that the gateway handles card data on its own infrastructure (never on the site's server).
- [ ] Run the WooCommerce DB migration immediately after updating the plugin — do not leave it pending.
- [ ] If not needed, remove comment functionality from the blog and products.

### Client account
- [ ] Create a **Shop Manager** account (never Administrator).
- [ ] Restrict the client from accessing theme settings. [See code](./docs/Restrict-Shop-Manager-accessing-theme-settings.php)
- [ ] Check that the client account can access products but cannot access the theme or plugins.

---

## Phase 4: Pre-launch and security review
- [ ] Run a security scanner (`WPScan`, `Imunify`) on the site and resolve critical vulnerabilities.
- [ ] Document accepted-risk decisions: every vulnerability that cannot be remediated must have a documented justification, the compensating controls applied, and a review date.
- [ ] Verify Response Headers via `BurpSuite` or at <https://securityheaders.com/>. [Base headers](./docs/Base%20headers.php)
- [ ] Confirm that the `X-Powered-By` header is not set.
- [ ] Confirm that user enumeration via the API returns 401 (`/wp-json/wp/v2/users`). [See guide](./docs/Disable-user-listing.php)
- [ ] Verify login lockout (`Wordfence` brute-force protection).
- [ ] Verify backup integrity in a local environment. [See basic guide](./docs/Runbook:%20WordPress%20Backup%20Restoration%20and%20Check.md)
- [ ] Change CSP from `report-mode` to `enforcement-mode`. [See script](./utils/check_csp.sh)
- [ ] Verify that `Cloudflare Turnstile` works on all public forms.
- [ ] Verify author enumeration: visit `/?author=1` — it must not reveal the admin's username.
- [ ] Run a Wordfence CLI scan on a local copy for a full scan without memory restrictions (more thorough than the `WP Admin` scanner).
- [ ] Verify that there is no sensitive data in the source code (PHP version, email addresses, API keys, debug output). [See script](./utils/scan_sensitive_data.sh)
- [ ] Confirm that there are no .php files inside `wp-content/uploads/` (a sign of a webshell).
- [ ] Verify that `.htaccess` in `wp-content/uploads/` blocks PHP execution. [See guide](./docs/Block-php-in-wpcontent-uploads.md)
- [ ] Verify permissions on critical directories:
    - `wp-config.php` → 600
    - `uploads/`, `plugins/`, `themes/` → 755
    - Never 777 on any file or directory.

---