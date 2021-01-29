ARG PHP_VERSION=7.4

FROM repo-clicksports.clicksports.de/docker/php-fpm:${PHP_VERSION}

ENV APP_ENV development

RUN apt-get update \
    && apt-get install -y \
        nano \
    && rm -rf /var/lib/apt/lists/*

# copy bash layout
COPY .bashrc /root/.bashrc
COPY --chown=www-data:www-data .bashrc /var/www/.bashrc

# extract php source
RUN docker-php-source extract

# get php ext sources
RUN docker-php-ext-get xdebug 3.0.2

# install php modules
RUN docker-php-ext-install xdebug

# delete php source
RUN docker-php-source delete

# set php ini and apache config
RUN rm /usr/local/etc/php/php.ini-development \
    && rm /usr/local/etc/php/php.ini-production

COPY php.ini /usr/local/etc/php/php.ini

# copy the start script
COPY docker/app/docker-entrypoint.sh /docker-entrypoint.sh

# chmod the start script
RUN chmod +x /docker-entrypoint.sh

# add www-data to sudoers
RUN echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER www-data

# set the entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]