FROM composer:2.10.3 AS builder

WORKDIR /usr/src/myapp

COPY composer.* .
ARG IMPLEMENTATION_VERSION
RUN if [ -n "$IMPLEMENTATION_VERSION" ]; then composer require "opis/json-schema:$IMPLEMENTATION_VERSION" --update-no-dev --no-scripts --no-interaction --prefer-dist --optimize-autoloader; else composer install --no-dev --no-scripts --no-interaction --prefer-dist --optimize-autoloader; fi
COPY bowtieJsonSchema.php .
RUN composer dump-autoload --no-dev --optimize --classmap-authoritative

FROM php:8.6.0beta2-fpm-alpine

WORKDIR /usr/src/myapp

RUN apk add --no-cache lsb-release-minimal
COPY bowtieJsonSchema.php .
COPY --from=builder /usr/src/myapp/vendor /usr/src/myapp/vendor

CMD ["php", "bowtieJsonSchema.php"]
