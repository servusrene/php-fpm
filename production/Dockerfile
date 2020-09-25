## Start Production Setup
FROM cs-php-fpm AS cs-php-fpm-prod

ENV APP_ENV production

# set php ini and apache config
RUN rm /usr/local/etc/php/php.ini-development \
    && rm /usr/local/etc/php/php.ini-production

COPY php.ini /usr/local/etc/php/php.ini