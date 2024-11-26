ARG PHP_VERSION=8.0

FROM ghcr.io/rene-mueller/php-fpm:${PHP_VERSION}

ENV PHP_OPCACHE_JIT='' \
    APP_ENV=development \
    XDEBUG_MODE=debug \
    XDEBUG_CONFIG='profiler_output_name=cachegrind.out.%R client_host=host.docker.internal output_dir=/var/www/tmp' \
    PHP_IDE_CONFIG='serverName=docker'

RUN apk update \
    && apk add --no-cache \
        nano \
    && rm -rf /var/cache/apk/*

# copy bash layout
COPY .bashrc /root/.bashrc
COPY --chown=www-data:www-data .bashrc /var/www/.bashrc

# install xdebug
# TODO remove if when xdebug is ready
RUN if dpkg --compare-versions "$PHP_VERSION" "lt" "8.3.0"; then \
    docker-php-source extract \
 && docker-php-ext-get xdebug 3.2.1 \
 && docker-php-ext-install xdebug \
 && docker-php-source delete \
 # make tmp directory for xdebug results (profiler, ..)
  mkdir -m 0777 /var/www/tmp \
; fi


USER www-data

EXPOSE 9000
CMD ["php-fpm"]