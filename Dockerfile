FROM php:7.4-fpm AS php-fpm

RUN apt-get update

RUN apt-get install -y \
        libpq-dev \
    && docker-php-ext-install -j$(nproc) \
        pdo_pgsql

RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM php-fpm AS dev

ENV COMPOSER_VERSION=2.1.5
ENV BIN_PATH=/usr/local/bin

RUN apt-get update \
    && apt-get install -y \
    neovim \
    git

RUN apt-get install sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && usermod -aG sudo www-data

RUN mkdir /legalvisio \
  && chown www-data: /legalvisio \
  && usermod --shell /bin/bash --home /legalvisio www-data

RUN curl -sS https://getcomposer.org/installer | php -- --version=$COMPOSER_VERSION --install-dir=$BIN_PATH --filename=composer \
    && curl -sS https://get.symfony.com/cli/installer | bash -s -- --install-dir=$BIN_PATH

USER www-data