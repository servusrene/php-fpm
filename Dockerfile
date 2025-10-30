ARG PHP_VERSION=8.1

FROM php:${PHP_VERSION}-fpm-alpine

LABEL servusrene.php-fpm.maintainer="René"
LABEL servusrene.php-fpm.version="1.7"

ENV PHP_MAX_EXECUTION_TIME=60 \
    PHP_MEMORY_LIMIT='512M' \
    PHP_ERROR_REPORTING='E_ALL' \
    PHP_DISPLAY_ERRORS='On' \
    PHP_POST_MAX_SIZE='16M' \
    PHP_UPLOAD_MAX_FILESIZE='16M' \
    PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    PHP_OPCACHE_REVALIDATE_FREQ=1 \
    PHP_OPCACHE_JIT='tracing' \
    PHP_OPCACHE_PRELOAD='' \
    PHP_OPCACHE_USER='www-data'

# set workdir
WORKDIR /var/www/html

#set SHELL
SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# add sh scripts
COPY docker-php-ext-get /usr/local/bin/
COPY version-compare /usr/local/bin/
RUN chmod +x /usr/local/bin/version-compare

# install non php modules
RUN apk update \
    && apk add --no-cache \
        freetype-dev \
        libgomp \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        imagemagick-dev \
        openssl-dev \
        libzip-dev \
        libxml2-dev \
        oniguruma-dev \
        imap-dev \
        krb5-dev \
        curl-dev \
        zlib-dev \
        icu-dev \
        curl \
        zip \
        unzip \
        git \
    && rm -rf /var/cache/apk/*

# Configure and install PHP extensions
RUN set -eux; \
    docker-php-source extract \
  # Configure and install extensions based on PHP version
  && if version-compare "$PHP_VERSION" ge 8.4.0; then \
      # PHP 8.4+: pdo, xml, curl are built-in; imap moved to PECL
      docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
      && docker-php-ext-install \
        gd \
        zip \
        mbstring \
        pdo_mysql \
        mysqli \
        calendar \
        intl \
        opcache \
        pcntl \
      # Install imap from PECL
      && docker-php-ext-get imap 1.0.3 \
      && docker-php-ext-install imap; \
    else \
      # PHP < 8.4: traditional extension installation
      PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
      && docker-php-ext-configure gd --with-freetype=/usr/local/ --with-jpeg=/usr/local/ --with-webp=/usr/local \
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
        intl \
        opcache \
        pcntl; \
    fi \
  # Install imagick via PECL (all versions)
  && docker-php-ext-get imagick 3.8.0 \
  && docker-php-ext-install imagick \
  && docker-php-source delete

# copying php ini, values should be set via ENV
RUN rm /usr/local/etc/php/php.ini-development \
    && rm /usr/local/etc/php/php.ini-production

COPY php.ini /usr/local/etc/php/php.ini

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
