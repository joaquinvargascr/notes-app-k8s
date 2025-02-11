
FROM php:8.3-apache-bookworm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    netcat-traditional \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    libpq-dev \
    libwebp-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg=/usr --with-webp \
    && docker-php-ext-install -j "$(nproc)" gd mbstring zip pdo pdo_mysql pdo_pgsql opcache;

# Enable Apache modules
RUN set -eux; \
    if command -v a2enmod; then \
        a2enmod expires rewrite; \
    fi
# Install Composer globally
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/

# Laravel version
ENV LARAVEL_VERSION ^11

# https://github.com/moby/buildkit/issues/4503
# https://github.com/composer/composer/issues/11839
# https://github.com/composer/composer/issues/11854
# https://github.com/composer/composer/blob/94fe2945456df51e122a492b8d14ac4b54c1d2ce/src/Composer/Console/Application.php#L217-L218
ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /opt/laravel
RUN set -eux; \
    export COMPOSER_HOME="$(mktemp -d)"; \
    composer create-project --no-interaction "laravel/laravel:$LARAVEL_VERSION" ./; \
    composer check-platform-reqs; \
    chown -R www-data:www-data bootstrap storage; \
    rmdir /var/www/html; \
    ln -sf /opt/laravel/public /var/www/html; \
    rm -rf "$COMPOSER_HOME"

COPY ./app app
COPY ./database database
COPY ./routes routes
COPY ./resources/views/notes resources/views/notes

ENV PATH=${PATH}:/opt/laravel/vendor/bin

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]