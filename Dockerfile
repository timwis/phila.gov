FROM wordpress:4.9.7-php7.1-apache

ARG DEBIAN_FRONTEND=noninteractive

# install
WORKDIR /var/www/html
COPY ./wp ./

# wp cli
RUN set -ex \
  && curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp \
  && chmod 755 /usr/local/bin/wp

# node.js
RUN apt-get update \
  && apt-get install -y gnupg build-essential

RUN set -ex \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -y nodejs

WORKDIR /var/www/html/wp-content/themes/phila.gov-theme

RUN npm install \
  && npm run build
