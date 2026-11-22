<!-- Safe to use in any Wordpress site with the proper adjustments. -->

<IfModule mod_headers.c>
    Header always set X-Content-Type-Options "nosniff"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    Header always unset X-Powered-By
    Header unset X-Powered-By
</IfModule>

