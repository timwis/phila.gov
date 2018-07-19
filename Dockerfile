FROM php:7.2-apache

ENV WORDPRESS_VERSION 4.9.6
ENV WORDPRESS_SHA1 40616b40d120c97205e5852c03096115c2fca537

ENV php_opcache /usr/local/etc/php/conf.d/opcache-recommended.ini

# wp cli
RUN set -ex \
  && curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp \
  && chmod 755 /usr/local/bin/wp

# node.js
RUN apt-get update \
  && apt-get install -y gnupg build-essential \
  && set -ex \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -y nodejs

# aws-cli
RUN apt-get update && \
  apt-get install -y \
    python \
    python-dev \
    python-pip \
    python-setuptools \
    groff \
    less \
  && pip install awscli

# unzip (for private plugins)
RUN apt-get update \
  && apt-get install -y unzip

# php extensions
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libjpeg-dev \
    libpng-dev \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install gd mysqli opcache zip

# php settings
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } > ${php_opcache} \
  && a2enmod rewrite expires

# install wordpress (upstream image puts it in wrong location)
RUN curl -o wordpress.tar.gz -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C /usr/src/ \
  && rm wordpress.tar.gz \
  && chown -R www-data:www-data /usr/src/wordpress \
  && mv /usr/src/wordpress/* /var/www/html/

# install
COPY ./wp /var/www/html/
COPY ./scripts/* /usr/local/bin/

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "start" ]
