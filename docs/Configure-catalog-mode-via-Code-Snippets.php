// Ocultar precios
add_filter('woocommerce_get_price_html', '__return_empty_string');
remove_action('woocommerce_single_product_summary', 'woocommerce_template_single_price', 10);
remove_action('woocommerce_after_shop_loop_item_title', 'woocommerce_template_loop_price', 10);

// Eliminar "Agregar al carrito"
remove_action('woocommerce_single_product_summary', 'woocommerce_template_single_add_to_cart', 30);
remove_action('woocommerce_after_shop_loop_item', 'woocommerce_template_loop_add_to_cart', 10);

// Redirigir pagina de Carrito y Checkout
add_action('template_redirect', function() {
    if (is_cart() || is_checkout()) { wp_redirect(home_url()); exit; }
});

// Desabilitar emails de ordenes de compra
add_filter('woocommerce_email_enabled_new_order', '__return_false');
add_filter('woocommerce_email_enabled_customer_processing_order', '__return_false');
add_filter('woocommerce_email_enabled_customer_completed_order', '__return_false');
add_filter('woocommerce_email_enabled_customer_invoice', '__return_false');

// Desabilitar la creacion de cuenta a los visitantes
add_action('template_redirect', function() {
    if (is_account_page() && !is_user_logged_in()) { wp_redirect(home_url()); exit; }
});