ARG BASEIMAGE=ghcr.io/ntj125app/openlitespeed:base

# Base Image
FROM ${BASEIMAGE} AS base

ARG PHP_VERSION
ARG LS_VERSION
ARG PHP_DETAIL_VERSION

# Install Base PHP
RUN apt-get install -y ${LS_VERSION} ${LS_VERSION}-common ${LS_VERSION}-curl ${LS_VERSION}-dbg ${LS_VERSION}-dev ${LS_VERSION}-imap ${LS_VERSION}-intl ${LS_VERSION}-ldap ${LS_VERSION}-modules-source ${LS_VERSION}-mysql ${LS_VERSION}-opcache ${LS_VERSION}-pgsql ${LS_VERSION}-pspell ${LS_VERSION}-snmp ${LS_VERSION}-sqlite3 ${LS_VERSION}-sybase ${LS_VERSION}-tidy && \
    apt-get autoclean -y && \
    ln -sf /usr/local/lsws/${LS_VERSION}/bin/php /usr/bin/php && \
    ln -sf /usr/local/lsws/${LS_VERSION} /usr/local/lsws/lsactive &&\
    chmod a+x /entrypoint.sh

COPY ./php.d/max-file-upload.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/max-file-upload.ini
COPY ./php.d/mem-limit.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/mem-limit.ini

# Install Base PHP Extensions
RUN /usr/bin/pecl install redis && \
    apt-get autoclean -y

COPY ./php.d/20-redis.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-redis.ini

RUN /usr/bin/pecl install mongodb && \
    apt-get autoclean -y

COPY ./php.d/20-mongodb.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-mongodb.ini

RUN /usr/bin/pecl install excimer && \
    apt-get autoclean -y

COPY ./php.d/20-excimer.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-excimer.ini

RUN apt-get install -y libmemcached-dev zlib1g-dev pkg-config && \
    /usr/bin/pecl install memcached && \
    apt-get autoclean -y

COPY ./php.d/20-memcached.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-memcached.ini

RUN apt-get install -y libbrotli-dev && \
    /usr/bin/pecl install swoole || true && \
    apt-get autoclean -y

COPY ./php.d/20-swoole.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-swoole.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM base AS pcov

ARG PCOV_VERSION=1.0.11

# Install PCOV
RUN /usr/bin/pecl install pcov && \
    apt-get autoclean -y

COPY ./php.d/99-pcov.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-pcov.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM base AS xdebug

# Install XDEBUG
RUN /usr/bin/pecl install xdebug || true && \
    apt-get autoclean -y

COPY ./php.d/99-xdebug.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-xdebug.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM base AS oci

ARG ORACLE_VERSION=21.15.0.0.0
ARG ORACLE_SIMPLE_VERSION=2115000
ARG ORACLE_ZIP_DIR=instantclient_21_15
ARG OCI_VERSION=3.4.0
ARG PDO_OCI_VERSION=1.1.0

# Install Oracle Instant Client
RUN apt-get install -y libaio-dev libaio1 unzip && mkdir -p /usr/oracle && \
    curl https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_SIMPLE_VERSION}/instantclient-basic-linux.x64-${ORACLE_VERSION}dbru.zip --output /usr/oracle/oic.zip && \
    curl https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_SIMPLE_VERSION}/instantclient-sdk-linux.x64-${ORACLE_VERSION}dbru.zip --output /usr/oracle/sdk.zip && \
    cd /usr/oracle && \
    unzip oic.zip && \
    unzip sdk.zip && \
    rm -f oic.zip && \
    rm -f sdk.zip && \
    apt-get autoclean -y

ENV LD_LIBRARY_PATH=/usr/oracle/${ORACLE_ZIP_DIR}

RUN curl https://pecl.php.net/get/oci8-${OCI_VERSION}.tgz --output /oci8-${OCI_VERSION}.tgz && \
    cd / && \
    tar -zxvf /oci8-${OCI_VERSION}.tgz && \
    cd /oci8-${OCI_VERSION} && \
    /usr/local/lsws/${LS_VERSION}/bin/phpize && \
    ./configure -with-oci8=instantclient,/usr/oracle/${ORACLE_ZIP_DIR} --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
    make install && \
    rm -r /oci8-${OCI_VERSION} && \
    rm -r /oci8-${OCI_VERSION}.tgz && \
    apt-get autoclean -y

COPY ./php.d/20-oci8.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-oci8.ini

COPY ./php.d/20-pdo_oci.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/20-pdo_oci.ini

RUN if [ "${PDO_OCI_VERSION}" !== "1.0" && "${PDO_OCI_VERSION}" !== "1" ]; then \
        mv /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/20-pdo_oci.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-pdo_oci.ini; \
        curl https://pecl.php.net/get/pdo_oci-${PDO_OCI_VERSION}.tgz --output /pdo_oci-${PDO_OCI_VERSION}.tgz && \
        cd / && \
        tar -zxvf /pdo_oci-${PDO_OCI_VERSION}.tgz && \
        cd /pdo_oci-${PDO_OCI_VERSION} && \
        /usr/local/lsws/${LS_VERSION}/bin/phpize && \
        ./configure -with-pdo_oci=instantclient,/usr/oracle/${ORACLE_ZIP_DIR} --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
        make install && \
        rm -r /pdo_oci-${PDO_OCI_VERSION} && \
        rm -r /pdo_oci-${PDO_OCI_VERSION}.tgz && \
        apt-get autoclean -y; \
    fi && \
    php -v && \
    php -m

# Target Image
FROM oci AS oci-pcov

# Install PCOV
RUN /usr/bin/pecl install pcov && \
    apt-get autoclean -y

COPY ./php.d/99-pcov.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-pcov.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM oci AS oci-xdebug

# Install XDEBUG
RUN /usr/bin/pecl install xdebug || true && \
    apt-get autoclean -y

COPY ./php.d/99-xdebug.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-xdebug.ini
