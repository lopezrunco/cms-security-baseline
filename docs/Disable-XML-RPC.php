<!-- 
Run this command to check if XML-RPC is enabled:
    curl -sL https://website.com.uy/xmlrpc.php
If you get this response "XML-RPC server accepts POST requests only.", 
it means the services is enabled and needs to be disable by adding the following code to .htaccess: 
-->

<Files "xmlrpc.php">
    Order Deny,Allow
    Deny from all
</Files>

<!-- After adding the code, run the initial command again and it should return a 403.-->