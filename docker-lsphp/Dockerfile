ARG BASEIMAGE=ghcr.io/ntj125app/openlitespeed:base

# Base Image
FROM ${BASEIMAGE} AS base-ols

ARG PHP_VERSION
ARG LS_VERSION
ARG PHP_DETAIL_VERSION

# Install Base PHP
RUN apt-get install -y ${LS_VERSION} ${LS_VERSION}-common ${LS_VERSION}-curl ${LS_VERSION}-dbg ${LS_VERSION}-dev ${LS_VERSION}-imap ${LS_VERSION}-intl ${LS_VERSION}-ldap ${LS_VERSION}-modules-source ${LS_VERSION}-mysql ${LS_VERSION}-opcache ${LS_VERSION}-pgsql ${LS_VERSION}-pspell ${LS_VERSION}-snmp ${LS_VERSION}-sqlite3 ${LS_VERSION}-sybase ${LS_VERSION}-tidy && \
    apt-get autoclean -y && \
    ln -sf /usr/local/lsws/${LS_VERSION}/bin/php /usr/bin/php && \
    ln -sf /usr/local/lsws/${LS_VERSION} /usr/local/lsws/lsactive &&\
    chmod a+x /entrypoint.sh && \
    pecl channel-update pecl.php.net

COPY ./php.d/max-file-upload.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/max-file-upload.ini
COPY ./php.d/mem-limit.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/mem-limit.ini

# Check PHP Version
RUN php -v && \
    php -m

FROM base-ols AS base-php-redis

# Install Base PHP Extensions
RUN /usr/bin/pecl install redis && \
    apt-get autoclean -y

COPY ./php.d/20-redis.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-redis.ini

# Check PHP Version
RUN php -v && \
    php -m

FROM base-php-redis AS base-php-mongodb

RUN /usr/bin/pecl install mongodb && \
    apt-get autoclean -y

COPY ./php.d/20-mongodb.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-mongodb.ini

# Check PHP Version
RUN php -v && \
    php -m

FROM base-php-mongodb AS base-php-excimer

RUN /usr/bin/pecl install excimer && \
    apt-get autoclean -y

COPY ./php.d/20-excimer.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-excimer.ini

# Check PHP Version
RUN php -v && \
    php -m

FROM base-php-excimer AS base-php-memcached

RUN apt-get install -y libmemcached-dev zlib1g-dev pkg-config && \
    /usr/bin/pecl install memcached && \
    apt-get autoclean -y

COPY ./php.d/20-memcached.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-memcached.ini

# Check PHP Version
RUN php -v && \
    php -m

FROM base-php-memcached AS base

COPY ./php.d/20-swoole.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-swoole.ini

RUN apt-get install -y libbrotli-dev && \
    /usr/bin/pecl install swoole || rm -r /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-swoole.ini && \
    apt-get autoclean -y

# Check PHP Version
RUN php -v && \
    php -m
