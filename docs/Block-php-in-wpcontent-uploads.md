1. Crear o modificar el archivo `.htaccess` en `wp-content/uploads/` y agregar las siguientes lineas:

```sh
<FilesMatch "\.(?i:php|php3|php4|php5|php7|php8|phtml|pht)$">
    <IfModule mod_authz_core.c>
        Require all denied
    </IfModule>
    <IfModule !mod_authz_core.c>
        Order allow,deny
        Deny from all
    </IfModule>
</FilesMatch>
```

2. Verificar: Crear un archivo temporal llamado `test.php` dentro de `wp-content/uploads/` con el siguiente código: 

```php
<?php echo "Vulnerable"; ?>
```

3. Desde la terminal correr `curl -I https://dominio.com.uy/wp-content/uploads/test.php`.

4. Si el servidor devuelve un error 403 Forbidden (o 404), la protección quedó activa con éxito.

5. Eliminar el archivo `test.php` despues de terminada la prueba.