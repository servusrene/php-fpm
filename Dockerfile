ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm

LABEL maintainer="Alexander Schlegel, René Müller CLICKSPORTS"
LABEL DOCKER_IMAGE_VERSION="1.2"

# set workdir
WORKDIR /var/www/html

# add bash scripts
COPY docker-php-ext-get /usr/local/bin/

# install non php modules
RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libmagickwand-dev \
        libssl-dev \
        libzip-dev \
        libxml2-dev \
        libonig-dev \
        libc-client-dev \
        libkrb5-dev \
        libcurl4-openssl-dev \
        zlib1g-dev \
        curl \
        zip \
        unzip \
        git \
    && rm -rf /var/lib/apt/lists/*

# Configure imap
RUN set -eux; PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl

# Configure GD
RUN if $(dpkg --compare-versions "$PHP_VERSION" "lt" "7.4.0") ; then \
    docker-php-ext-configure gd --with-freetype-dir=/usr/local/ --with-jpeg-dir=/usr/local/  \
  ; else \
    docker-php-ext-configure gd --with-freetype=/usr/local/ --with-jpeg=/usr/local/ \
  ; fi

# extract php source
RUN docker-php-source extract

# get php ext sources
RUN docker-php-ext-get imagick 3.4.4

# install php modules
RUN docker-php-ext-install \
    imap \
    gd \
    zip \
    mbstring \
    pdo \
    pdo_mysql \
    xml \
    mysqli \
    curl \
    calendar \
    imagick

# delete php source
RUN docker-php-source delete

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html
