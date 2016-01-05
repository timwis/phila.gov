<?php
/**
 * The template used for displaying a content collection
 *
 * @package phila-gov
 */
	$walker_menu = new Content_Collection_Walker();
  $connected_sections = new WP_Query( array(
    'connected_type' => 'pages_to_sections',
    'connected_items' => get_queried_object(),
    'nopaging' => true,
  ) );



	if($post->post_parent) {
			$children = wp_list_pages(array(
				'include' => $connected_sections->ID,
				'walker' => $walker_menu
				));
			$page_title = get_the_title($post->post_parent);
		} ?>
		<div class="data-swiftype-index='true'">
		<div class="row">
			<header class="entry-header small-24 columns">
				<h1><?php echo $page_title; ?></h1>
			</header>
		</div>
		<article id="post-<?php the_ID(); ?>">
			<div class="row">
				<div class="small-24 columns">
						<aside>
							<ul class="tabs vertical">
								<?php	echo $children; ?>
							</ul>
						</aside>
		    <div data-swiftype-name="body" data-swiftype-type="text" class="entry-content tabs-content">
		      <div class="content active">
						<header class="entry-header">
							<?php the_title( '<h2 class="entry-title">', '</h2>' ); ?>
						</header><!-- .entry-header -->
					  <?php the_content(); ?>
					</div>
		    </div><!-- .entry-content -->
			</div>
		</div>
	</div>
		<?php get_template_part( 'partials/content', 'modified' ) ?>
	</article><!-- #post-## -->
