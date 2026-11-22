# Install semgrep using pip:

pip install semgrep --break-system-packages

# Run a scan against the custom theme, using WordPress-specific and PHP rulesets:

cd /website-folder/wp-content/themes/custom-theme

semgrep --config=p/php --config=p/wordpress --config=p/security-audit .

# `p/php`: Common PHP vulnerability patterns (insecure includes/requires, with variable paths, eval(), serialization issues, etc.)
# `p/wordpress`: WordPress-specific: missing nonces, unescaped output, unsanitized $_GET/$_POST, missing prepare() in $wpdb queries.
# `p/security-audit`: OWASP-type checks (SSRF, path traversal, command injection patterns).

# Always document results:

semgrep --config=p/php --config=p/wordpress --config=p/security-audit . --output=semgrep-report.txt