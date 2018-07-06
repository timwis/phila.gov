FROM ubuntu:16.04

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

RUN set -ex \
  && apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    nginx \
    php5-cli \
    php5-curl \
    php5-fpm \
    php5-gd \
    php5-mysql

# Composer
RUN set -ex \
  && curl -sS https://getcomposer.org/download/1.0.0-alpha10/composer.phar > /usr/local/bin/composer \
  && chmod 755 /usr/local/bin/composer \

# wp cli
RUN set -ex \
  && curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp \
  && chmod 755 /usr/local/bin/wp
