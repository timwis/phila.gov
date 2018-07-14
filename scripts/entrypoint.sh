#!/bin/bash
CMD=$1

wp-config.sh "$CMD"
private-plugins.sh "$CMD"

# Install node dependencies
pushd /var/www/html/wp-content/themes/phila.gov-theme
npm install

# Run node build scripts
case "$CMD" in
  "dev" )
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
