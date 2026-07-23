# Checklist de Seguridad en Sitios Web

**Stack:** cPanel - Wordpress/Joomla
**Ultima actualizacion:** 23-07-2026

---

## Fase 1: Hardening y Seguridad basica

### Nucleo del CMS
- [ ] Eliminar contenido de ejemplo, paginas de ejemplo y usuarios de prueba.
- [ ] Borrar plantillas y plugins no usados.
- [ ] Cambiar nombre de usuario por defecto ("admin").
- [ ] Implementar contraseñas seguras en todas las cuentas.
- [ ] Implementar Factor de autenticación Multiple en cuentas de administrador.
- [ ] Mover paginas de acceso (como `wp-login` o `administrator`) a una URL personalizada (WPS Hide Login plugin).
- [ ] Ni no se necesita, deshabilitar `XML-RPC` en [.htaccess](./docs/Disable-XML-RPC.php).
- [ ] Agregar security headers via `.htaccess` (CSP report-only, X-Frame-Options, HSTS, Permissions-Policy).
- [ ] Setear los permisos de `wp-config.php` en 640 via cPanel.
- [ ] Deshabilitar la edicion de archivos de plantilla o plugins via Administracion. [Ver codigo](./docs/Disable-file-editing-WP-dashboard.php)
- [ ] Forzar el uso de SSL para administradores. [Ver codigo](./docs/Enable-forced-SSL-for-admin.php)
- [ ] Eliminar archivos tipo `readme.html` y `license.txt` de la raiz de la web.
- [ ] Eliminar la version del CMS del generador meta tag. [Ver codigo](./docs/Remove-WP-version-from-meta-generator-tag.php)
- [ ] Habilitar registro de debug a archivo (Nunca al navegador). [Ver codigo](./docs/Enable-debug-logging-to-file.php)
- [ ] Agregar captcha a todos los formularios publicos (Cloudflare Turnstile recomendado).
- [ ] Verificar que los salts en `wp-config.php` son unicos (Generarlos en https://api.wordpress.org/secret-key/1.1/salt/).
- [ ] Crear una plantilla hija antes de personalizar.

### Hosting / cPanel

- [ ] Habilitar certificado HTTPS si no esta activado por defecto via cPanel.
- [ ] Forzar redireccion HTTP => HTTPS en `.htaccess`.
- [ ] Chequear que ModSecurity WAF este habilitado en el cPanel.
- [ ] Restringir el listado de directorio en `.htaccess` (`Options -Indexes`).
- [ ] Confirmar que la version de PHP sea reciente.

---

## Fase 2: Auditoria de plantilla y plugins

### Plantilla
- [ ] Auditar y eliminar contenido demo, sliders, paginas y productos de ejemplo.
- [ ] Registrar la licencia de la plantilla para recibir notificaciones de actualizaciones.
- [ ] Deshabilitar features de la plantilla que no se usen (page builders, headers sin usar).
- [ ] Confirmar que la plantilla hija esta activa antes de cualqueir personalizacion.

### Plugins
- [ ] Auditar todos los plugins instalados y eliminar los que no sean necesarios. 
- [ ] Actualizar todos los plugins a la ultima version.
- [ ] Instalar Wordfence/Akeeba Admin Tools (WAF y proteccion en el login).
- [ ] Instalar WP Activity Log para auditar actividad.
- [ ] Instalar plugin para manejo de cache (LiteSpeed Cache).
- [ ] Instalar plugin de optimizacion de imagenes (Imagify or ShortPixel) (Mejora el redimiento y reduce la superficie de ataque ante un DoS).

---

## Fase 3: Configuración de tienda (Woocommerce/Virtuemart)

### Configuración basica
- [ ] Setear correctamente pais y moneda.
- [ ] En el caso de modo catalogo, configurarlo mediante [PHP](./docs/Configure-catalog-mode-via-Code-Snippets.php).

### Cuenta para el cliente
- [ ] Crear cuenta de tipo Manager de cuenta (nunca Administrador).
- [ ] Restringir al cliente de acceder a la configuración de la plantilla. [Ver codigo](./docs/Restrict-Shop-Manager-accessing-theme-settings.php)
- [ ] Testear cuenta del cliente (puede acceder a productos, no puede acceder a plantilla/plugins).

---

## Fase 4: Pre-lanzamiento y Review de Seguridad
- [ ] Correr escaner de seguridad (WPScan, Imunify) en el sitio y resolver vulnerabilidades criticas.
- [ ] Verificar que no hay datos sensibles en el codigo fuente (version PHP, emails, claves API, debug output).
- [ ] Chequear Response Headers via BurpSuite o en securityheaders.com
- [ ] Confirmar que el encabezado `X-Powered-By` no esté configurado.
- [ ] Confirmar que la enumeracion de usuarios desde la API retorna 401 (`/wp-json/wp/v2/users`) 
- [ ] Confirmar que `WP_DEBUG` esta apagado en `wp-config.php`.
- [ ] Testear bloqueo de login (Proteccion de Wordfence contra ataques de fuerza bruta).
- [ ] Testear restauracion de backup en entorno local.
- [ ] Cambiar CSP de `report-mode` a `enforcement-mode`.
- [ ] Verificar que Cloudflare Turnstile funciona en todos los formularios publicos.

---