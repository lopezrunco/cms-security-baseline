<!-- Seguros de usar en cualquier sitio de Wordpress. Ajustar de forma acorde en cada caso. -->

<IfModule mod_headers.c>
    Header always set X-Content-Type-Options "nosniff"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    Header always unset X-Powered-By
    Header unset X-Powered-By
</IfModule>

