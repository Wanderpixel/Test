FROM trafex/php-nginx:latest

USER root

WORKDIR /app

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apk add --update --no-cache php82-pdo_mysql php82-simplexml bash nodejs npm php82-pecl-xdebug git
RUN apk add --update --no-cache php82-sodium php82-iconv php82-zip

USER nobody
