##
# php-fpm/Dockerfile
#
# @license Apache-2.0
# @maintainer <github.com/farwish>
##

ARG PHP_VERSION

FROM php:${PHP_VERSION}

RUN apt-get update && apt-get install -y \
        git                    \
        libfreetype6-dev       \
        libjpeg62-turbo-dev    \
        libpng-dev             \
        gettext                \
        libmcrypt-dev          \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure gettext --with-gettext=/usr/include/ \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install calendar \
    && docker-php-ext-install exif \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install shmop \
    && docker-php-ext-install sockets \
    && docker-php-ext-install zip \
    && docker-php-ext-install opcache

