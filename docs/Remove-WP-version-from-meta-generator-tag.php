<!-- Add the following code to functions.php: -->

remove_action('wp_head', 'wp_generator');
add_filter('the_generator', '__return_empty_string');

<!-- 
To verify, run this script in the temrinal:
    curl -s https://website.com.uy/ | grep -i '<meta name="generator"' 

Compliant: no output.
Non-compliant: you see something like <meta name="generator" content="WordPress 6.x.x" />.
-->
