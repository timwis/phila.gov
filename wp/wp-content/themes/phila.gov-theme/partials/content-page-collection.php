<?php
/**
 * The template used for displaying a content collection
 *
 * @package phila-gov
 */
 ?>
<?php $post_slug = $post->post_name; ?>
<section id="<?php echo $post_slug  ?>" class="content">
  <header class="entry-header">
    <?php the_title( '<h2 class="entry-title">', '</h2>' ); ?>
  </header><!-- .entry-header -->
  <div data-swiftype-name="body" data-swiftype-type="text" class="entry-content">
    <?php the_content(); ?>
  </div>
</section><!-- #post-## -->
<hr>
