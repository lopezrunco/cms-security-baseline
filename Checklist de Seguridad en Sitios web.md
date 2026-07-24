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

### Hosting / cPanel

- [ ] Habilitar certificado HTTPS si no está activado por defecto vía cPanel.
- [ ] Forzar redireccion HTTP => HTTPS en `.htaccess`.
- [ ] Chequear que ModSecurity WAF esté habilitado en cPanel.
- [ ] Restringir el listado de directorio en `.htaccess` (`Options -Indexes`).
- [ ] Confirmar que la versión de PHP sea reciente.

---

## Fase 2: Auditoría de plantilla y plugins

### Plantilla
- [ ] Auditar y eliminar contenido demo, sliders, páginas y productos de ejemplo.
- [ ] Registrar la licencia de la plantilla para recibir notificaciones de actualizaciones.
- [ ] Deshabilitar funcionalidades de la plantilla que no se usen (page builders, encabezados sin usar).
- [ ] Confirmar que la plantilla hija está activa antes de cualquier personalización.

### Plugins
- [ ] Auditar todos los plugins instalados y eliminar los que no sean necesarios.
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

### Cuenta para el cliente
- [ ] Crear cuenta de tipo **Gestor de la tienda** (nunca Administrador).
- [ ] Restringir al cliente de acceder a la configuración de la plantilla. [Ver código](./docs/Restrict-Shop-Manager-accessing-theme-settings.php)
- [ ] Comprobar que la cuenta del cliente puede acceder a productos, pero no puede acceder a la plantilla ni a los plugins.

---

## Fase 4: Pre-lanzamiento y revisión de Seguridad
- [ ] Ejecutar escáner de seguridad (`WPScan`, `Imunify`) en el sitio y resolver vulnerabilidades críticas.
- [ ] Verificar que no hay datos sensibles en el código fuente (versión PHP, correos electrónicos, claves API, resultados de depuración).
- [ ] Verificar Response Headers vía `BurpSuite` o en <https://securityheaders.com/>.
- [ ] Confirmar que el encabezado `X-Powered-By` no esté configurado.
- [ ] Confirmar que la enumeración de usuarios desde la API devuelve 401 (`/wp-json/wp/v2/users`) 
- [ ] Confirmar que `WP_DEBUG` está apagado en `wp-config.php`.
- [ ] Verificar bloqueo de login (Protección de `Wordfence` contra ataques de fuerza bruta).
- [ ] Verificar integridad del respaldo en entorno local.
- [ ] Cambiar CSP de `report-mode` a `enforcement-mode`.
- [ ] Verificar que `Cloudflare Turnstile` funciona en todos los formularios públicos.

---