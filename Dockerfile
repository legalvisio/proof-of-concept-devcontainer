FROM php:7.4-fpm AS php-fpm

FROM php-fpm AS dev

RUN apt-get update \
    && apt-get install -y \
    neovim

RUN apt-get install sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && usermod -aG sudo www-data

RUN mkdir /legalvisio \
  && chown www-data: /legalvisio \
  && usermod --shell /bin/bash --home /legalvisio www-data

USER www-data