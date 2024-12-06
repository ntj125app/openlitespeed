ARG PHP_VERSION
ARG LS_VERSION
ARG PHP_DETAIL_VERSION
ARG BASEIMAGE=ghcr.io/ntj125app/openlitespeed:${LS_VERSION}-base

# Target Image
FROM ${BASEIMAGE} AS pcov

ARG PCOV_VERSION=1.0.11

# Install PCOV
RUN /usr/bin/pecl install pcov && \
    apt-get autoclean -y

COPY ./php.d/99-pcov.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-pcov.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM ${BASEIMAGE} AS xdebug

# Install XDEBUG
RUN /usr/bin/pecl install xdebug && \
    apt-get autoclean -y

COPY ./php.d/99-xdebug.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-xdebug.ini

# Check PHP Version
RUN php -v && \
    php -m

# Target Image
FROM ${BASEIMAGE} AS oci

ARG ORACLE_VERSION=21.15.0.0.0
ARG ORACLE_SIMPLE_VERSION=2115000
ARG ORACLE_ZIP_DIR=instantclient_21_15
ARG OCI_VERSION=3.4.0
ARG OCI_PDO_INSTALL=0

# Install Oracle Instant Client
RUN apt-get install -y libaio-dev libaio1 unzip && mkdir -p /usr/oracle && \
    curl https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_SIMPLE_VERSION}/instantclient-basic-linux.x64-${ORACLE_VERSION}dbru.zip --output /usr/oracle/oic.zip && \
    curl https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_SIMPLE_VERSION}/instantclient-sdk-linux.x64-${ORACLE_VERSION}dbru.zip --output /usr/oracle/sdk.zip && \
    cd /usr/oracle && \
    unzip oic.zip && \
    unzip sdk.zip && \
    rm -f oic.zip && \
    rm -f sdk.zip && \
    apt-get autoclean -y && \
    echo /usr/oracle/${ORACLE_ZIP_DIR} > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

RUN if [ "${OCI_VERSION}" != "1.0" && "${OCI_VERSION}" != "1" ]; then \
        yes "instantclient,/usr/oracle/${ORACLE_ZIP_DIR}" | pecl install oci8-${OCI_VERSION}; \
        rm -f /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-pdo_oci.ini; \
    else \
        yes "instantclient,/usr/oracle/${ORACLE_ZIP_DIR}" | pecl install oci8; \
    fi

COPY ./php.d/20-oci8.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-oci8.ini

COPY ./php.d/20-pdo_oci.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-pdo_oci.ini

RUN if [ "${OCI_PDO_INSTALL}" -eq 1 ]; then \
        echo 'Installing OCI8 PDO'; \
        yes "instantclient,/usr/oracle/${ORACLE_ZIP_DIR}" | pecl install pdo_oci; \
    else \
        echo 'Skipping . . . Installing OCI8 PDO'; \
        rm -f /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/20-pdo_oci.ini; \
    fi

# Check PHP Version
RUN php -v && \
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
RUN /usr/bin/pecl install xdebug && \
    apt-get autoclean -y

COPY ./php.d/99-xdebug.ini /usr/local/lsws/${LS_VERSION}/etc/php/${PHP_VERSION}/mods-available/99-xdebug.ini
