FROM wordpress:4.9.7-php7.1-apache

ARG DEBIAN_FRONTEND=noninteractive

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

# move wordpress from upstream image into correct location
RUN cp -R /usr/src/wordpress /var/www/html/

# install
COPY ./wp /var/www/html
COPY ./scripts /usr/local/bin/

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "start" ]
