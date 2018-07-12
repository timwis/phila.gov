#!/bin/bash
CMD=$1

wp-config
rm wp-config.php
wp config create \
  --dbhost="$WORDPRESS_DB_HOST" \
  --dbname="$WORDPRESS_DB_NAME" \
  --dbuser="$WORDPRESS_DB_USER" \
  --dbpass="$WORDPRESS_DB_PASSWORD" \
  --skip-check \
  --allow-root \
  --extra-php <<PHP
/** WP_SITEURL overrides DB to set WP core address */
define('WP_SITEURL', 'https://$DOMAIN');

/** WP_HOME overrides DB to set public site address */
define('WP_HOME', 'https://$DOMAIN');

/** For AWS and S3 usage */
define('AWS_ACCESS_KEY_ID', '$AWS_ID');
define('AWS_SECRET_ACCESS_KEY', '$AWS_SECRET');

define( 'WPOS3_SETTINGS', serialize( array(
  'bucket' => '$PHILA_MEDIA_BUCKET',
  'cloudfront' => '$DOMAIN'
) ) );

/** For Swiftype search */
define('SWIFTYPE_ENGINE', '$SWIFTYPE_ENGINE');

/** For Google Calendar Archives */
define('GOOGLE_CALENDAR', '$GOOGLE_CALENDAR');

/** Don't let stuff sit around too long */
define('EMPTY_TRASH_DAYS', 7);

/** Disable WP cron, it runs on every page load! */
define('DISABLE_WP_CRON', true);

/** We manually update WP, so disable auto updates */
define('WP_AUTO_UPDATE_CORE', false);

/** https://wordpress.org/support/topic/problem-after-the-recent-update */
define('FS_METHOD', 'direct');
PHP

# Install private plugins
plugins="mb-admin-columns-1.3.0.zip
mb-revision-1.1.1.zip
meta-box-columns-1.2.3.zip
meta-box-conditional-logic-1.5.5.zip
meta-box-group-1.2.13.zip
meta-box-include-exclude-1.0.9.zip
meta-box-tabs-1.0.3.zip
meta-box-tooltip-1.1.1.zip
wpfront-user-role-editor-personal-pro-2.14.1.zip"

for plugin in $plugins; do
  echo "Installing $plugin"
  s3_url="s3://$PHILA_PLUGINS_BUCKET/$plugin"
  presigned_s3_url=$(aws s3 presign "$s3_url" --expires-in 600)
  wp plugin install --force --activate --allow-root "$presigned_s3_url"
done

# Install node dependencies
pushd /var/www/html/wp-content/themes/phila.gov-theme
npm install

# Run node build scripts
case "$CMD" in
  "dev" )
    wp config set WP_DEBUG true --raw --type=constant --allow-root
    wp config set WP_DEBUG_LOG true --raw --type=constant --allow-root
    wp config set WP_DEBUG_DISPLAY true --raw --type=constant --allow-root

    npm run dev:build
    ;;
  "start" )
    npm run build
    ;;
  * )
    exec $CMD ${@:2}
    ;;
esac

popd

# run wordpress entrypoint with default cmd
exec /usr/local/bin/docker-entrypoint.sh "apache2-foreground"
