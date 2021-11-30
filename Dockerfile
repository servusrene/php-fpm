ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm

LABEL clicksports.php-fpm.maintainer="Alexander Schlegel, René Müller CLICKSPORTS"
LABEL clicksports.php-fpm.version="1.4"

ENV PHP_MAX_EXECUTION_TIME 60
ENV PHP_MEMORY_LIMIT '512M'
ENV PHP_ERROR_REPORTING 'E_ALL'
ENV PHP_DISPLAY_ERRORS 'On'
ENV PHP_UPLOAD_MAX_FILESIZE '16M'
ENV PHP_OPCACHE_ENABLE 1
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS 1
ENV PHP_OPCACHE_REVALIDATE_FREQ 1
ENV PHP_OPCACHE_JIT 'tracing'
ENV PHP_OPCACHE_PRELOAD ''

# set workdir
WORKDIR /var/www/html

#set SHELL
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# add bash scripts
COPY docker-php-ext-get /usr/local/bin/

# install non php modules
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libwebp-dev \
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
RUN set -eux; PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    # Configure GD
  && docker-php-ext-configure gd --with-freetype=/usr/local/ --with-jpeg=/usr/local/ --with-webp=/usr/local \
  # install php modules
  && docker-php-ext-install \
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
    opcache \
    && if dpkg --compare-versions "$PHP_VERSION" "lt" "8.0.0"; then \
      docker-php-source extract && \
      docker-php-ext-get imagick 3.5.2 && \
      docker-php-ext-install imagick \
    ; fi \
  && docker-php-source delete

# copying php ini, values should be set via ENV
RUN rm /usr/local/etc/php/php.ini-development \
    && rm /usr/local/etc/php/php.ini-production

COPY php.ini /usr/local/etc/php/php.ini

COPY --from=composer:2.0 /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html
