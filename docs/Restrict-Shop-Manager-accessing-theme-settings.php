add_filter('user_has_cap', function($caps, $_cap, $_args, $user) {
    if (in_array('shop_manager', $user->roles ?? [])) {
        $caps['edit_theme_options'] = false;
        $caps['switch_themes'] = false;
    }
    return $caps;
}, 10, 4);