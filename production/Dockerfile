ARG PHP_VERSION=7.4

FROM repo-clicksports.clicksports.de/docker/php-fpm:${PHP_VERSION}

ENV APP_ENV=production \
    PHP_DISPLAY_ERRORS='Off' \
    PHP_ERROR_REPORTING='' \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0

USER www-data