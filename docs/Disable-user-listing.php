<!-- Agregar este codigo en functions.php -->

add_filter('rest_endpoints', function($endpoints) {
    // Verificar si la ruta de usuarios existe en la petición
    if (isset($endpoints['/wp/v2/users'])) {
        // Si el usuario actual no está autenticado, bloquear el acceso
        if (!current_user_can('read')) {
            unset($endpoints['/wp/v2/users']);
            unset($endpoints['/wp/v2/users/(?P<id>[\d]+)']);
        }
    }
    return $endpoints;
});


<!-- Vertificar corriendo este comando: 

curl -I https://sitio.uy/wp-json/wp/v2/users 

Deberia de retornar 404 -->