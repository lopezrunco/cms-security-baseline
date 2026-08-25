# Instalar semgrep usando pip:

pip install semgrep --break-system-packages

# Correr escaneo contra la plantilla personalizada, usando rulesets especificos de WordPress-specific y PHP:

cd /website-folder/wp-content/themes/custom-theme

semgrep --config=p/php --config=p/wordpress --config=p/security-audit .

# `p/php`: Patrones de vulnerabilidades comunes de PHP (includes/requires inseguros, con variable paths, eval(), problemas de serializacion, etc.)
# `p/wordpress`: Especificos de WordPress: monces perdidos, salidas no escapadas, $_GET/$_POST no sanitizados, ausencia de prepare() en consultas $wpdb. 
# `p/security-audit`: Chequeos de tipo OWASP (SSRF, path traversal, command injection patterns).

# Siempre documentar resultados:

semgrep --config=p/php --config=p/wordpress --config=p/security-audit . --output=semgrep-report.txt