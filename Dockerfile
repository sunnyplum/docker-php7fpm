FROM php:7-fpm-alpine AS build-gd-xdebug

ARG LABEL_Maintainer='Richard Li <trqingli@gmail.com>'
ARG LABEL_Description='Docker build file for php7-fpm with CMS-develop essential extensions (gd, database, xdebug).'

ARG APK_DEPS_RUN_GD='freetype libpng libjpeg-turbo'
ARG APK_DEPS_BUILD_GD='freetype-dev libpng-dev libjpeg-turbo-dev'
ARG APK_DEPS_BUILD_XDEBUG='autoconf g++ make'

RUN apk --update add ${APK_DEPS_BUILD_GD} ${APK_DEPS_BUILD_XDEBUG} && \
    pecl update-channels && \
    pecl install xdebug && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include && \
    docker-php-ext-install gd pdo_mysql && \
    docker-php-ext-enable xdebug && \
    apk del ${APK_DEPS_BUILD_XDEBUG} && \
    rm -f /var/cache/apk/*

######################################################################
# Shared parameters for both the later targets.
ARG DIR_PHP_EXT='/usr/local/lib/php/extensions/no-debug-non-zts-20180731'
ARG DIR_PHP_EXT_INI='/usr/local/etc/php/conf.d'

######################################################################
FROM php:7-fpm-alpine AS dev

LABEL Maintainer ${LABEL_Maintainer}
LABEL Description ${LABEL_Description}

RUN apk --update add ${APK_DEPS_RUN_GD} && \
    rm -f /var/cache/apk/*

COPY --from=build-gd-xdebug ${DIR_PHP_EXT}/ ${DIR_PHP_EXT}/
COPY --from=build-gd-xdebug ${DIR_PHP_EXT_INI}/ ${DIR_PHP_EXT_INI}/

#######################################################################
FROM php:7-fpm-alpine AS prod

LABEL Maintainer ${LABEL_Maintainer}
LABEL Description ${LABEL_Description}

COPY --from=build-gd-xdebug ${DIR_PHP_EXT}/ ${DIR_PHP_EXT}/
COPY --from=build-gd-xdebug ${DIR_PHP_EXT_INI}/ ${DIR_PHP_EXT_INI}/

RUN apk --update add ${APK_DEPS_RUN_GD} && \
    # @TODO ${DIR_PHP_EXT}/xdebug.so does not work here.
    rm -f /usr/local/lib/php/extensions/no-debug-non-zts-20180731/xdebug.so && \
    rm -f /var/cache/apk/*
