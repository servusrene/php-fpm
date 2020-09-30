ARG PHP_VERSION=7.4

FROM repo-clicksports.clicksports.de/docker/php-fpm:${PHP_VERSION}

ENV APP_ENV development

RUN apt-get update \
    && apt-get install -y \
        nano

COPY .bashrc /root/.bashrc
COPY .bashrc /var/www/.bashrc

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# set php ini and apache config
RUN rm /usr/local/etc/php/php.ini-development \
    && rm /usr/local/etc/php/php.ini-production

COPY php.ini /usr/local/etc/php/php.ini

USER www-data
