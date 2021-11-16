ARG PHP_VERSION=7.4

FROM repo-clicksports.clicksports.de/docker/php-fpm:${PHP_VERSION}

ENV PHP_OPCACHE_JIT ''
ENV APP_ENV development
ENV XDEBUG_MODE debug
ENV XDEBUG_CONFIG 'profiler_output_name=cachegrind.out.%R client_host=host.docker.internal output_dir=/var/www/tmp'
ENV PHP_IDE_CONFIG serverName=docker

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        nano \
    && rm -rf /var/lib/apt/lists/*

# copy bash layout
COPY .bashrc /root/.bashrc
COPY --chown=www-data:www-data .bashrc /var/www/.bashrc

# extract php source
RUN docker-php-source extract

# get php ext sources
RUN docker-php-ext-get xdebug 3.0.4

# install php modules
RUN docker-php-ext-install xdebug

# delete php source
RUN docker-php-source delete

# make tmp direcotry for xdebug results (profiler, ..)
RUN mkdir -m 0777 /var/www/tmp

USER www-data

EXPOSE 9000
CMD ["php-fpm"]