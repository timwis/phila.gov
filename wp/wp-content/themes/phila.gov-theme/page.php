<?php
/**
 * The template for displaying all Pages.
 *
 * This will display either a content collection or a
 *
 * @package phila-gov
 */

get_header();
$connected_sections = new WP_Query( array(
  'connected_type' => 'pages_to_sections',
  'connected_items' => get_queried_object(),
  'nopaging' => true,
  'connected_direction' => 'from'
  )
);

?>
<div id="primary" class="content-area row">
  <main id="main" class="site-main small-24 columns" role="main">

    <?php if ( have_posts() ) : ?>

     <?php while ( have_posts() ) : the_post(); ?>

        <div class="row">
          <header class="entry-header small-24 columns">
            <?php the_title( '<h1 class="entry-title">', '</h1>' ); ?>
          </header><!-- .entry-header -->
        </div>

       <?php endwhile; ?>
     <?php endif; ?>

     <div class="row">
       <nav class="medium-8 columns">

        <?php // Display connected pages
        if ( $connected_sections->have_posts() ) : ?>

          <ul class="tabs vertical">
            <li class="tab-title"><a href="<?php get_permalink(); ?>"> Overview </a></li>
            <?php while ( $connected_sections->have_posts() ) : $connected_sections->the_post();

                get_template_part('partials/content', 'nav' );

             endwhile; ?>
          </ul>
         </nav>
         <div class="medium-16 columns">

          <?php //body content
            if ( have_posts() ) : ?>
            <?php while ( have_posts() ) : the_post();

              echo '<h2>Overview</h2>';
              the_content(); ?>
              <hr>

              <?php endwhile; ?>
            <?php endif;

            while ( $connected_sections->have_posts() ) : $connected_sections->the_post();

              get_template_part( 'partials/content', 'page-collection' );

            endwhile; ?>

      <?php endif; ?>
      </div>
    </div>
    <?php wp_reset_postdata(); ?>

  </main><!-- #main -->
</div><!-- #primary -->
<?php get_template_part( 'partials/content', 'modified' ) ?>
<?php get_footer(); ?>
