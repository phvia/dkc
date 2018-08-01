ARG COMPOSER_VERSION

FROM composer:${COMPOSER_VERSION}

WORKDIR /usr/share/nginx/html/so-fw

RUN set -ex         \
    rm -rf var/     \
    mkdir var/      \
    chmod -R 0777   \
    chown www-data:www-data

CMD ["composer", "install"]
