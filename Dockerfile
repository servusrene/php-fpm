ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm 

LABEL maintainer="Alexander Schlegel, René Müller CLICKSPORTS"
LABEL DOCKER_IMAGE_VERSION="1.2"

# add bash scripts
COPY docker-php-ext-get /usr/local/bin/

# install non php modules
RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
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

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html
