<?php
/**
  * Filter the post type links to add or remove slugs as necessary.
  *
  * @uses https://developer.wordpress.org/reference/hooks/post_type_link/
  * @param $post_link Current post links
  * @param $id
  * @param $post_type Get the post type
  *
  *
*/
add_filter( 'post_type_link', 'phila_add_category_slugs_to_post_links', 1, 3 );

function phila_add_category_slugs_to_post_links( $post_link, $id = 0, $post_type ) {

  $post = get_post( $id );

  if ( is_wp_error( $post ) || empty( $post->post_name ) )
    return $post_link;

    $terms = get_the_terms( $post->ID, 'category' );

    if( is_wp_error( $terms ) || !$terms ) {
      $cat = 'uncategorised';
    } else {
      $cat_obj = array_pop($terms);
      $cat = $cat_obj->slug;
    }

    switch ($post->post_type) {

      case 'notices':
        return home_url( user_trailingslashit( "notices/$cat/$post->post_name" ) );

        break;

      case 'phila_post' :
        $post_date = get_the_date('Y-m-d');

        return home_url( user_trailingslashit( "posts/$cat/$post_date-$post->post_name" ) );

        break;

      case 'press_release':
        return home_url( user_trailingslashit( "press-releases/$cat/$post->post_name" ) );

        break;

      case 'news_post':
        return home_url( user_trailingslashit( "news/$cat/$post->post_name" ) );

        break;

      case 'service_post':
        $post_link = get_home_url() . '/' . $post->post_name . '/';

        return $post_link;
        break;

      case 'department_page':
        $post_link = str_replace( '/' . 'departments' . '/', '/', $post_link );

        return $post_link;
        break;

      default:
        return $post_link;

  }
}

/**
* Add the service_post post type back to the current query, because it has been  removed from the slug.
*
* Thanks to: http://ryansechrest.com/2013/04/remove-post-type-slug-in-custom-post-type-url-and-move-subpages-to-website-root-in-wordpress/
* Tell WP what kind of post we are dealing with, since the slug is gone now.
*
* @uses https://developer.wordpress.org/reference/hooks/pre_get_posts/
*
* @param $query Wordpress query object
*/

add_action( 'pre_get_posts', 'pre_get_posts_services' );

function pre_get_posts_services( $query ) {
  global $wpdb;

  if( ! $query->is_main_query() ) {
    return;
  }

  //only need to match on the post name because this is an non-hierarchical post type
  $post_name = $query->get( 'name' );

  $post_type = $wpdb->get_var(
    $wpdb->prepare(
      'SELECT post_type FROM ' . $wpdb->posts . ' WHERE post_name = %s LIMIT 1', $post_name
    )
  );

  switch( $post_type ) {

    case 'service_post':

      $post_name = $post_name;

      //find the correct data for the post
      $query->set('service_post', $post_name);

      //set the correct post type
      $query->set('post_type', $post_type);

      //to load the correct post type
      $query->is_single = true;

      //it's a cpt, so page is false
      $query->is_page = false;

      break;

  }
}

/**
* Add the department_page post type back to the current query, because it has been  removed from the slug.
*
* Thanks to: http://ryansechrest.com/2013/04/remove-post-type-slug-in-custom-post-type-url-and-move-subpages-to-website-root-in-wordpress/
* Tell WP what kind of post we are dealing with, since the slug is gone now.
*
* @uses https://developer.wordpress.org/reference/hooks/pre_get_posts/
*
* @param $query Wordpress query object
*/

add_action( 'pre_get_posts', 'pre_get_posts_departments', 1 );

function pre_get_posts_departments( $query ) {
  global $wpdb;
  global $wp;

  //don't do this in all these places
  if( ( !$query->is_main_query() ) || ( is_admin() ) || is_archive() || is_tax() || is_page() ) {
    return;
  }

  $post_name = $query->get( 'name' );
  $post_type = $query->get( 'post_type' );

  $all_post_types = get_post_types();

  $all_post_types = array_merge(array_diff($all_post_types, array('department_page')));

  //leave all other post types alone
  if ( in_array( $post_type, $all_post_types ) ){
    return;
  }

  $result = $wpdb->get_row(
    $wpdb->prepare(
      'SELECT wpp1.post_type, wpp2.post_name AS parent_post_name FROM ' . $wpdb->posts . ' as wpp1 LEFT JOIN ' . $wpdb->posts . ' as wpp2 ON wpp1.post_parent = wpp2.ID WHERE wpp1.post_name = %s LIMIT 1',
      $post_name
    )
  );

  //this will give us the URL we need. maybe we should do something like trying to match on the whole url
  $current_query =  add_query_arg( $_SERVER['QUERY_STRING'], '', home_url( $wp->request ) );

  $path = parse_url($current_query, PHP_URL_PATH);

  $path_pieces = explode("/", $path);

  if( !empty( $result->post_type ) ) {

    switch( $result->post_type ) {

      case 'department_page':

      /*use the path entered to match the correct page */
      if( isset( $path_pieces[2] ) ) {
        if ($path_pieces[2] != ''){
          $post_name = $path_pieces[1] . '/' . $path_pieces[2];
        }
      }

      $query->set( 'department_page', $post_name );
      $query->set( 'post_type', $result->post_type );
      $query->is_single = true;
      $query->is_page = false;

      break;
    }
  }
}
