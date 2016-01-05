<?php
/**
 * The template for displaying all pages.
 *
 * This is the template that displays all pages by default.
 * Please note that this is the WordPress construct of pages
 * and that other 'pages' on your WordPress site will use a
 * different template.
 *
 * @package phila-gov
 */

get_header();
 // Find connected pages
 $connected_sections = new WP_Query( array(
   'connected_type' => 'pages_to_sections',
   'connected_items' => get_queried_object(),
   'nopaging' => true,
 ) );

?>
  <div id="primary" class="content-area row">
    <main id="main" class="site-main small-24 columns" role="main">

      <?php  // Display connected pages
       if ( $connected_sections->have_posts() ) : ?>
       <ul>
       <?php while ( $connected_sections->have_posts() ) : $connected_sections->the_post();

        $this_content = get_the_content();

        if ( count( $connected_sections ) != 0 && ( $this_content == 0 ) )  {
            //this page is a parent, with content

            get_template_part( 'partials/content', 'page-collection' );
        }elseif(($post->id = $post->post_parent)) {
            get_template_part( 'partials/content', 'page-collection' );
        }else {
            get_template_part( 'partials/content', 'page' );
          }

        endwhile;

      endif;
      wp_reset_postdata();

      ?>

    </main><!-- #main -->
  </div><!-- #primary -->

<?php get_footer(); ?>
