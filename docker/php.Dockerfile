# ----------------------
# The FPM base container
# ----------------------
FROM php:8.0-fpm as dev

RUN apt-get update 
RUN apt-get install -qy libmcrypt-dev zlib1g-dev libzip-dev default-mysql-client libpng-dev
RUN docker-php-ext-install -j$(nproc) pdo_mysql gd 

WORKDIR /app

# ----------------------
# Composer install step
# ----------------------
FROM composer:2 as build

WORKDIR /app

COPY composer.* ./
COPY database/ database/

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

# ----------------------
# npm install step
# ----------------------
FROM node:16-alpine as node

WORKDIR /app

COPY *.json *.mix.js /app/
COPY resources /app/resources

RUN mkdir -p /app/public \
    && npm install && npm run dev

# ----------------------
# The FPM production container
# ----------------------
FROM dev

COPY ./docker/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/php.ini /usr/local/etc/php/conf.d/php.ini
COPY . /app

# laravel mix / webpack 
COPY --from=build /app/vendor/ /app/vendor/
COPY --from=node /app/public/js/ /app/public/js/
COPY --from=node /app/public/css/ /app/public/css/
COPY --from=node /app/mix-manifest.json /app/public/mix-manifest.json
