ARG PHP_VERSION=8.1

FROM ghcr.io/servusrene/php-fpm:${PHP_VERSION}

ENV PHP_OPCACHE_JIT='' \
    APP_ENV=development \
    XDEBUG_MODE=debug \
    XDEBUG_CONFIG='profiler_output_name=cachegrind.out.%R client_host=host.docker.internal output_dir=/var/www/tmp' \
    PHP_IDE_CONFIG='serverName=docker'

RUN apk update \
    && apk add --no-cache \
        nano \
    && rm -rf /var/cache/apk/*

# install xdebug
RUN docker-php-source extract \
 && docker-php-ext-get xdebug 3.4.7 \
 && docker-php-ext-install xdebug \
 && docker-php-source delete \
 # make tmp directory for xdebug results (profiler, ..)
 && mkdir -m 0777 /var/www/tmp

USER www-data

EXPOSE 9000
CMD ["php-fpm"]
