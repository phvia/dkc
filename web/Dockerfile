##
# ARG 需要分开定义
#
# $ dkc exec web bash
# $ composer install -v
##

ARG PHP_VERSION

FROM phvia/php-fpm:${PHP_VERSION}

USER root

# Modify user www-data uid to 1000
RUN usermod -u 1000 www-data

# --from use .env variable is invalid ! why ?
COPY --from=composer:1.6 /usr/bin/composer /usr/bin/composer

ARG WEB_PATH

RUN mkdir -p ${WEB_PATH}

RUN chown -R www-data:www-data ${WEB_PATH}
RUN chown -R www-data:www-data /var/www

WORKDIR ${WEB_PATH}

# 切用户
USER www-data

