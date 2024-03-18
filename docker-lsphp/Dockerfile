ARG BASEIMAGE

# Base Image
FROM ${BASEIMAGE} AS base

ARG PHP_VERSION
ARG LS_VERSION
ARG PHP_DETAIL_VERSION

ARG REDIS_VERSION=6.0.2
ARG EXCIMER_VERSION=1.2.2
ARG MEMCACHED_VERSION=3.2.0
ARG OPENSWOOLE_VERSION=22.1.2

# Install Base PHP
RUN apt-get install -y ${LS_VERSION} ${LS_VERSION}-common ${LS_VERSION}-curl ${LS_VERSION}-dbg ${LS_VERSION}-dev ${LS_VERSION}-imap ${LS_VERSION}-intl ${LS_VERSION}-ldap ${LS_VERSION}-modules-source ${LS_VERSION}-mysql ${LS_VERSION}-opcache ${LS_VERSION}-pgsql ${LS_VERSION}-pspell ${LS_VERSION}-snmp ${LS_VERSION}-sqlite3 ${LS_VERSION}-sybase ${LS_VERSION}-tidy && \
    apt-get autoclean -y && \
    ln -sf /usr/local/lsws/${LS_VERSION}/bin/php /usr/bin/php && \
    chmod a+x /entrypoint.sh && \
    mkdir -p /tmp/lshttpd/cache && \
    chown lsadm:lsadm -R /tmp/lshttpd/cache && \
    chmod a+rwx -R /tmp/lshttpd/cache && \
    ln -sf /usr/local/lsws/${LS_VERSION} /usr/local/lsws/lsactive

COPY ./php.d/max-file-upload.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/max-file-upload.ini
COPY ./php.d/mem-limit.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/mem-limit.ini

# Install Base PHP Extensions
RUN curl https://pecl.php.net/get/redis-${REDIS_VERSION}.tgz --output /redis-${REDIS_VERSION}.tgz && \
    cd / && \
    tar -zxf /redis-${REDIS_VERSION}.tgz && \
    cd /redis-${REDIS_VERSION} && \
    /usr/local/lsws/${LS_VERSION}/bin/phpize && \
    ./configure --enable-redis --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /redis-${REDIS_VERSION} && \
    rm -r /redis-${REDIS_VERSION}.tgz && \
    apt-get autoclean -y

COPY ./php.d/20-redis.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-redis.ini

RUN curl https://pecl.php.net/get/excimer-${EXCIMER_VERSION}.tgz --output /excimer-${EXCIMER_VERSION}.tgz && \
    cd / && \
    tar -zxf /excimer-${EXCIMER_VERSION}.tgz && \
    cd /excimer-${EXCIMER_VERSION} && \
    /usr/local/lsws/${LS_VERSION}/bin/phpize && \
    ./configure --enable-excimer --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /excimer-${EXCIMER_VERSION} && \
    rm -r /excimer-${EXCIMER_VERSION}.tgz && \
    apt-get autoclean -y

COPY ./php.d/20-excimer.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-excimer.ini

RUN apt-get install -y libmemcached-dev zlib1g-dev pkg-config && \
    curl https://pecl.php.net/get/memcached-${MEMCACHED_VERSION}.tgz --output /memcached-${MEMCACHED_VERSION}.tgz && \
    cd / && \
    tar -zxf /memcached-${MEMCACHED_VERSION}.tgz && \
    cd /memcached-${MEMCACHED_VERSION} && \
    /usr/local/lsws/${LS_VERSION}/bin/phpize && \
    ./configure --enable-memcached --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /memcached-${MEMCACHED_VERSION} && \
    rm -r /memcached-${MEMCACHED_VERSION}.tgz && \
    apt-get autoclean -y

COPY ./php.d/20-memcached.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-memcached.ini

RUN curl https://pecl.php.net/get/openswoole-${OPENSWOOLE_VERSION}.tgz --output /openswoole-${OPENSWOOLE_VERSION}.tgz && \
    cd / && \
    tar -zxf /openswoole-${OPENSWOOLE_VERSION}.tgz && \
    cd /openswoole-${OPENSWOOLE_VERSION} && \
    /usr/local/lsws/${LS_VERSION}/bin/phpize && \
    ./configure --enable-openswoole --enable-openssl --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /openswoole-${OPENSWOOLE_VERSION} && \
    rm -r /openswoole-${OPENSWOOLE_VERSION}.tgz && \
    apt-get autoclean -y

COPY ./php.d/20-openswoole.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-openswoole.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM base AS pcov

ARG PCOV_VERSION=1.0.11

# Install PCOV
RUN curl https://pecl.php.net/get/pcov-${PCOV_VERSION}.tgz --output /pcov-${PCOV_VERSION}.tgz && \
    cd / && \
    tar -zxf /pcov-${PCOV_VERSION}.tgz && \
    cd /pcov-${PCOV_VERSION} && \
    /usr/local/lsws/${LS_VERSION}/bin/phpize && \
    ./configure --enable-pcov --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /pcov-${PCOV_VERSION} && \
    rm -r /pcov-${PCOV_VERSION}.tgz && \
    apt-get autoclean -y

COPY ./php.d/99-pcov.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-pcov.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM base AS xdebug

ARG XDEBUG_VERSION=3.3.2

# Install XDEBUG
RUN curl https://pecl.php.net/get/xdebug-${XDEBUG_VERSION}.tgz --output /xdebug-${XDEBUG_VERSION}.tgz && \
    cd / && \
    tar -zxf /xdebug-${XDEBUG_VERSION}.tgz && \
    cd /xdebug-${XDEBUG_VERSION} && \
    /usr/local/lsws/${LS_VERSION}/bin/phpize && \
    ./configure --enable-xdebug --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /xdebug-${XDEBUG_VERSION} && \
    rm -r /xdebug-${XDEBUG_VERSION}.tgz && \
    apt-get autoclean -y

COPY ./php.d/99-xdebug.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-xdebug.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM base AS oci

ARG ORACLE_VERSION=21.13.0.0.0
ARG ORACLE_SIMPLE_VERSION=2113000
ARG ORACLE_ZIP_DIR=instantclient_21_13
ARG OCI_VERSION=3.3.0

# Install Oracle Instant Client
RUN apt-get install -y libaio-dev libaio1 unzip && mkdir -p /usr/oracle && \
    curl https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_SIMPLE_VERSION}/instantclient-basic-linux.x64-${ORACLE_VERSION}dbru.zip --output /usr/oracle/oic.zip && \
    curl https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_SIMPLE_VERSION}/instantclient-sdk-linux.x64-${ORACLE_VERSION}dbru.zip --output /usr/oracle/sdk.zip && \
    cd /usr/oracle && \
    unzip oic.zip && \
    unzip sdk.zip && \
    rm -f oic.zip && \
    rm -f sdk.zip && \
    echo /usr/oracle/${ORACLE_ZIP_DIR} > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig && \
    apt-get autoclean -y

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

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM oci AS oci-pcov

ARG PCOV_VERSION=1.0.11

# Install PCOV
RUN curl https://pecl.php.net/get/pcov-${PCOV_VERSION}.tgz --output /pcov-${PCOV_VERSION}.tgz && \
    cd / && \
    tar -zxf /pcov-${PCOV_VERSION}.tgz && \
    cd /pcov-${PCOV_VERSION} && \
    /usr/local/lsws/${LS_VERSION}/bin/phpize && \
    ./configure --enable-pcov --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /pcov-${PCOV_VERSION} && \
    rm -r /pcov-${PCOV_VERSION}.tgz && \
    apt-get autoclean -y

COPY ./php.d/99-pcov.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-pcov.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM oci AS oci-xdebug

ARG XDEBUG_VERSION=3.3.2

# Install XDEBUG
RUN curl https://pecl.php.net/get/xdebug-${XDEBUG_VERSION}.tgz --output /xdebug-${XDEBUG_VERSION}.tgz && \
    cd / && \
    tar -zxf /xdebug-${XDEBUG_VERSION}.tgz && \
    cd /xdebug-${XDEBUG_VERSION} && \
    /usr/local/lsws/${LS_VERSION}/bin/phpize && \
    ./configure --enable-xdebug --with-php-config=/usr/local/lsws/${LS_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /xdebug-${XDEBUG_VERSION} && \
    rm -r /xdebug-${XDEBUG_VERSION}.tgz && \
    apt-get autoclean -y

COPY ./php.d/99-xdebug.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-xdebug.ini
