##
# ARG 需要分开定义
#
# $ dkc exec web bash
# $ composer install -v
##

ARG PHP_VERSION

FROM php-img-farwish:${PHP_VERSION}

USER root

RUN usermod -u 1000 www-data

COPY --from=composer:1.6 /usr/bin/composer /usr/bin/composer

ARG PROJECT_PATH

RUN mkdir -p ${PROJECT_PATH}

RUN chown -R www-data:www-data ${PROJECT_PATH}
WORKDIR ${PROJECT_PATH}

# 切用户
USER www-data

# 此时还没有项目
#RUN composer install

