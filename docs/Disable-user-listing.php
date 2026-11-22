<!-- Add this code to functions.php -->

add_filter('rest_endpoints', function($endpoints) {
    // Verify if the "users" route exists in the request
    if (isset($endpoints['/wp/v2/users'])) {
        // If the current user is not authenticated, block the access.
        if (!current_user_can('read')) {
            unset($endpoints['/wp/v2/users']);
            unset($endpoints['/wp/v2/users/(?P<id>[\d]+)']);
        }
    }
    return $endpoints;
});


<!-- Verify by running: 

curl -I https://sitio.uy/wp-json/wp/v2/users 

It should return 404 -->