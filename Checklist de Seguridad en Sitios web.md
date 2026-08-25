# Checklist de seguridad en sitios web

**Stack:** cPanel - WordPress/Joomla
**Última actualización:** 23-07-2026

---

## Fase 1: Hardening y seguridad básica

### Núcleo del CMS
- [ ] Eliminar contenido de ejemplo, páginas de ejemplo y usuarios de prueba.
- [ ] Borrar plantillas y plugins no usados.
- [ ] Cambiar nombre de usuario por defecto ("admin").
- [ ] Implementar contraseñas seguras en todas las cuentas.
- [ ] Implementar factor de autenticación múltiple en cuentas de administrador.
- [ ] Mover páginas de acceso (como `wp-login` o `administrator`) a una URL personalizada (WPS Hide Login plugin).
- [ ] Si no se necesita, deshabilitar `XML-RPC` en `.htaccess`. [Ver código](./docs/Disable-XML-RPC.php)
- [ ] Agregar encabezados de seguridad vía `.htaccess` (CSP report-only, X-Frame-Options, HSTS, Permissions-Policy).
- [ ] Establecer los permisos de `wp-config.php` en 640 vía cPanel.
- [ ] Deshabilitar la edición de archivos de plantilla o plugins vía administración. [Ver código](./docs/Disable-file-editing-WP-dashboard.php)
- [ ] Forzar el uso de SSL para administradores. [Ver código](./docs/Enable-forced-SSL-for-admin.php)
- [ ] Eliminar archivos tipo `readme.html` y `license.txt` de la raíz de la web.
- [ ] Eliminar la versión del CMS del meta tag generator. [Ver código](./docs/Remove-WP-version-from-meta-generator-tag.php)
- [ ] Habilitar registro de debug a archivo (Nunca al navegador). [Ver código](./docs/Enable-debug-logging-to-file.php)
- [ ] Agregar captcha a todos los formularios públicos (Cloudflare Turnstile recomendado).
- [ ] Verificar que los salts en `wp-config.php` son únicos (generarlos en <https://api.wordpress.org/secret-key/1.1/salt/>).
- [ ] Crear una plantilla hija antes de personalizar.
- [ ] Verificar que las claves y salts de `wp-config.php` se rotan después de cualquier incidente de exposición de credenciales.
- [ ] Auditar todas las cuentas de usuario, eliminar cuentas heredadas o de prueba con credenciales no rotadas.
- [ ] Verificar que el plugins de migración (como `All-in-One WP Migration`) no estén instalados en producción. Si lo están, confirmar que el directorio de backups no es accesible públicamente.
- [ ] En el caso de ecommerce, chequear `WooCommerce` => `Salud del sitio` y remediar los hallazgos, si los hay.
- [ ] Aplicar principio de mínimo privilegio en cuentas de usuario:
    - Administrador: solo personal técnico
    - Gestor de tienda: cliente/operaciones
    - Nunca compartir cuentas entre personas
- [ ] Deshabilitar actualizaciones automaticas tanto en Wordpress, plantillas y plugins (Las mismas se realizarán manualmente previo staging). [Ver código](./docs/Disable-automatic-updates.php)

### Hosting / cPanel

- [ ] Habilitar certificado HTTPS si no está activado por defecto vía cPanel.
- [ ] Forzar redireccion HTTP => HTTPS en `.htaccess`. [Ver código](./docs/Force-HTTP-HTTPS-redirection.php)
- [ ] Chequear que ModSecurity WAF esté habilitado en cPanel.
- [ ] Restringir el listado de directorio (Agregar la linea `Options -Indexes` en `.htaccess`).
- [ ] Confirmar que la versión de PHP sea reciente.
- [ ] Confirmar que NO existen archivos de backup en `public_html` (`.wpress`, `.tar.gz`, `.zip`, `.sql`).
- [ ] Verificar accesibilidad directa de directorios de backup visitando sus URLs en el navegador.

---

## Fase 2: Auditoría de plantilla y plugins

### Plantilla
- [ ] Confirmar que la licencia de la plantilla está activa y es renovable. Una licencia vencida impide actualizaciones y crea una deuda de seguridad permanente.
- [ ] Auditar y eliminar contenido demo, sliders, páginas y productos de ejemplo.
- [ ] Registrar la licencia de la plantilla para recibir notificaciones de actualizaciones.
- [ ] Deshabilitar funcionalidades de la plantilla que no se usen (page builders, encabezados sin usar).
- [ ] Confirmar que la plantilla hija está activa antes de cualquier personalización.
- [ ] Auditar plugins bundled dentro de la plantilla (ej: `Slider Revolution` dentro de `Divi`) — pueden tener CVEs propios y no actualizarse de forma independiente.
- [ ] En el caso de plantillas personalizadas, buscar y remediar vulnerabilidades en el codigo, ya sea manualmente o con herramientas como `semgrep`. [Ver guia basica semgrep](./docs/Semgrep-use.sh)

### Plugins
- [ ] Auditar todos los plugins instalados y eliminar los que no sean necesarios.
- [ ] Para cada plugin: verificar en `Wordfence Threat Intel` o `WPScan` si hay CVEs conocidos en la versión instalada.
- [ ] Actualizar todos los plugins a la última versión.
- [ ] Instalar `Wordfence`/`Akeeba Admin Tools `(WAF y protección en el login).
- [ ] Instalar `WP Activity Log` para auditar actividad.
- [ ] Instalar plugin para manejo de caché (`LiteSpeed Cache`).
- [ ] Instalar plugin de optimización de imágenes (Imagify o ShortPixel) (Mejora el rendimiento y reduce la superficie de ataque frente a un DoS).

---

## Fase 3: Configuración de tienda (WooCommerce/VirtueMart)

### Configuración básica
- [ ] Establecer correctamente país y moneda.
- [ ] En el caso de modo catálogo, configurarlo mediante [PHP](./docs/Configure-catalog-mode-via-Code-Snippets.php).
- [ ] Verificar que el gateway de pago (`Mercado Pago`, `Handy`, etc.) está actualizado. Los plugins de pago son objetivos de alto valor y frecuentemente parchean vulnerabilidades silenciosamente.
- [ ] Confirmar que el gateway maneja los datos de tarjeta en su propia infraestructura (nunca en el servidor del sitio).
- [ ] Ejecutar DB migration de WooCommerce inmediatamente después de actualizar el plugin — no dejar pendiente.

### Cuenta para el cliente
- [ ] Crear cuenta de tipo **Gestor de la tienda** (nunca Administrador).
- [ ] Restringir al cliente de acceder a la configuración de la plantilla. [Ver código](./docs/Restrict-Shop-Manager-accessing-theme-settings.php)
- [ ] Comprobar que la cuenta del cliente puede acceder a productos, pero no puede acceder a la plantilla ni a los plugins.

---

## Fase 4: Pre-lanzamiento y revisión de Seguridad
- [ ] Ejecutar escáner de seguridad (`WPScan`, `Imunify`) en el sitio y resolver vulnerabilidades críticas.
- [ ] Documentar decisiones de riesgo aceptado — cualquier vulnerabilidad que no se pueda remediar debe tener: rationale documentado, compensating controls aplicados, y fecha de revisión.
- [ ] Verificar Response Headers vía `BurpSuite` o en <https://securityheaders.com/>.
- [ ] Confirmar que el encabezado `X-Powered-By` no esté configurado.
- [ ] Confirmar que la enumeración de usuarios desde la API devuelve 401 (`/wp-json/wp/v2/users`) 
- [ ] Verificar bloqueo de login (Protección de `Wordfence` contra ataques de fuerza bruta).
- [ ] Verificar integridad del respaldo en entorno local. [Ver guia basica](./docs/Runbook:%20WordPress%20Backup%20Restoration%20and%20Check.md)
- [ ] Cambiar CSP de `report-mode` a `enforcement-mode`.
- [ ] Verificar que `Cloudflare Turnstile` funciona en todos los formularios públicos.
- [ ] Verificar enumeración de autores: visitar `/?author=1` — no debe revelar nombre de usuario del admin.
- [ ] Ejecutar Wordfence CLI scan en copia local para escaneo completo sin restricciones de memoria (más completo que el scanner del `WP Admin`).
- [ ] Verificar que no hay datos sensibles en el código fuente (versión PHP, correos electrónicos, claves API, resultados de depuración).
- [ ] Confirmar que no hay archivos .php dentro de `wp-content/uploads/` (señal de webshell).
- [ ] Verificar que `.htaccess` en `wp-content/uploads/` bloquea ejecución de PHP.
- [ ] Verificar permisos de directorios críticos:
    - `wp-config.php` → 600
    - `uploads/`, `plugins/`, `themes/` → 755
    - Nunca 777 en ningún archivo o directorio.

---