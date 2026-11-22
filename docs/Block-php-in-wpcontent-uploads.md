1. Create or edit the `.htaccess` file in `wp-content/uploads/` and add the following lines:

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

2. Verify: Create a temporary file named `test.php` inside `wp-content/uploads/` with the following code:

```php
<?php echo "Vulnerable"; ?>
```

3. From the terminal, run `curl -I https://dominio.com.uy/wp-content/uploads/test.php`.

4. If the server returns a 403 Forbidden error (or 404), the protection is active and working.

5. Delete the `test.php` file once the test is complete.