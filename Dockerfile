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
    git \
    neovim \
    postgresql-client \
    zsh

RUN useradd --create-home vscode \
  && apt-get install -y sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && usermod -aG sudo vscode

RUN curl -sS https://getcomposer.org/installer | php -- --version=$COMPOSER_VERSION --install-dir=$BIN_PATH --filename=composer \
    && curl -sS https://get.symfony.com/cli/installer | bash -s -- --install-dir=$BIN_PATH

USER vscode

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

EXPOSE 8000