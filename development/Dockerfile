FROM cs-php-fpm AS cs-php-fpm-dev

ENV APP_ENV development

RUN apt-get update \
    && apt-get install -y \
        nano

COPY .bashrc /root/.bashrc

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
