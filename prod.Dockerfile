FROM php:7-fpm-alpine

ARG LABEL_Maintainer='Richard Li <trqingli@gmail.com>'
ARG LABEL_Description='Docker build file for php7-fpm with CMS-develop essential extensions (gd, database).'

LABEL Maintainer ${LABEL_Maintainer}
LABEL Description ${LABEL_Description}

ARG APK_DEPS_RUN_GD='freetype libpng libjpeg-turbo'
ARG APK_DEPS_BUILD_GD='freetype-dev libpng-dev libjpeg-turbo-dev'

RUN apk --update add ${APK_DEPS_BUILD_GD} ${APK_DEPS_RUN_GD} && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include && \
    docker-php-ext-install gd pdo_mysql && \
    apk del ${APK_DEPS_BUILD_GD} && \
    rm -f /var/cache/apk/*
