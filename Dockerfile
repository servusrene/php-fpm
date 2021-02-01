ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm

LABEL maintainer="Alexander Schlegel, René Müller CLICKSPORTS"
LABEL DOCKER_IMAGE_VERSION="1.2"

# set workdir
WORKDIR /var/www/html

#set SHELL
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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
RUN if echo "$PHP_VERSION" | grep -Eq '^7\.4'; then \
    docker-php-ext-configure gd --with-freetype-dir=/usr/local/ --with-jpeg-dir=/usr/local/  \
  ; else \
    docker-php-ext-configure gd --with-freetype=/usr/local/ --with-jpeg=/usr/local/ \
  ; fi


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
    calendar

# get php ext sources
# imagegick not working atm with php8
# see https://github.com/Imagick/imagick/issues/358
# waiting release for PECL package
RUN if echo "$PHP_VERSION" | grep -Eq '^8\.0'; then \
    docker-php-source extract && \
    docker-php-ext-get imagick 3.4.4 && \
    docker-php-ext-install imagick \
  ; fi

# delete php source
RUN docker-php-source delete

FROM composer:2.0 as composer
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html
