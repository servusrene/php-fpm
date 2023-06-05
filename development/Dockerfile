ARG PHP_VERSION=8.0

FROM ghcr.io/clicksports/php-fpm:${PHP_VERSION}

ENV PHP_OPCACHE_JIT='' \
    APP_ENV=development \
    XDEBUG_MODE=debug \
    XDEBUG_CONFIG='profiler_output_name=cachegrind.out.%R client_host=host.docker.internal output_dir=/var/www/tmp' \
    PHP_IDE_CONFIG='serverName=docker'

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        nano \
    && rm -rf /var/lib/apt/lists/*

# copy bash layout
COPY .bashrc /root/.bashrc
COPY --chown=www-data:www-data .bashrc /var/www/.bashrc

# install xdebug
RUN docker-php-source extract \
 && docker-php-ext-get xdebug 3.2.1 \
 && docker-php-ext-install xdebug \
 && docker-php-source delete \
 # make tmp directory for xdebug results (profiler, ..)
  mkdir -m 0777 /var/www/tmp

USER www-data

EXPOSE 9000
CMD ["php-fpm"]