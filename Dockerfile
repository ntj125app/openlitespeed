FROM debian:12-slim

    #UPDATE IMAGE
RUN apt-get update -y

RUN apt-get install -y curl && \
    curl https://repo.litespeed.sh | bash && \
    apt-get install -y ols-modsecurity && \
    apt-get autoclean -y

    # LSAPI MAKE
ENV EXTENSION_DIR /usr/local/lsws/lsphp82/lib64/php/modules
RUN apt-get install -y build-essential autoconf libtool bison re2c pkg-config && \
    # INSTALL SHARED LIBS
    apt-get install -y lsphp82 lsphp82-apcu lsphp82-apcu-dbgsym lsphp82-common lsphp82-curl lsphp82-dbg lsphp82-dev lsphp82-igbinary lsphp82-igbinary-dbgsym lsphp82-imagick lsphp82-imagick-dbgsym lsphp82-imap lsphp82-intl lsphp82-ldap lsphp82-memcached lsphp82-memcached-dbgsym lsphp82-modules-source lsphp82-msgpack lsphp82-msgpack-dbgsym lsphp82-mysql lsphp82-opcache lsphp82-pgsql lsphp82-pspell lsphp82-redis lsphp82-redis-dbgsym lsphp82-snmp lsphp82-sqlite3 lsphp82-sybase lsphp82-tidy && \
    apt-get autoclean -y

COPY ./php.d/max-file-upload.ini /usr/local/lsws/lsphp82/etc/php.d/max-file-upload.ini
COPY ./php.d/mem-limit.ini /usr/local/lsws/lsphp82/etc/php.d/mem-limit.ini

    # REDIS MAKE
RUN curl https://pecl.php.net/get/redis-6.0.2.tgz --output /redis-6.0.2.tgz && \
    cd / && \
    tar -zxf /redis-6.0.2.tgz && \
    cd /redis-6.0.2 && \
    /usr/local/lsws/lsphp82/bin/phpize && \
    ./configure --enable-redis --with-php-config=/usr/local/lsws/lsphp82/bin/php-config && \
    make install -j10 && \
    rm -r /redis-6.0.2 && \
    rm -r /redis-6.0.2.tgz && \
    apt-get autoclean -y

COPY ./php.d/20-redis.ini /usr/local/lsws/lsphp82/etc/php.d/20-redis.ini

    # EXCIMER MAKE
RUN curl https://pecl.php.net/get/excimer-1.1.1.tgz --output /excimer-1.1.1.tgz && \
    cd / && \
    tar -zxf /excimer-1.1.1.tgz && \
    cd /excimer-1.1.1 && \
    /usr/local/lsws/lsphp82/bin/phpize && \
    ./configure --enable-excimer --with-php-config=/usr/local/lsws/lsphp82/bin/php-config && \
    make install -j10 && \
    rm -r /excimer-1.1.1 && \
    rm -r /excimer-1.1.1.tgz && \
    apt-get autoclean -y

COPY ./php.d/20-excimer.ini /usr/local/lsws/lsphp82/etc/php.d/20-excimer.ini

    # LSWS PREP
RUN ln -sf /usr/local/lsws/lsphp82/bin/php /usr/bin/php && \
    mv /usr/local/lsws/conf /usr/local/lsws/conf-disabled

COPY ./lsws-conf /usr/local/lsws/conf

RUN mkdir -p /usr/local/lsws/modsec

COPY ./rules /usr/local/lsws/modsec/rules

RUN chown lsadm:lsadm -R /usr/local/lsws/conf && \
    chown lsadm:lsadm -R /usr/local/lsws/modsec/rules

COPY ./entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh && \
    mkdir -p /tmp/lshttpd/cache && \
    chown lsadm:lsadm -R /tmp/lshttpd/cache && \
    chmod a+rwx -R /tmp/lshttpd/cache

    # CHECK IF PHP INSTALLED CORRECTLY
RUN php -v && \
    php -m && \
    php -i

WORKDIR /var/www/vhosts/localhost

ENTRYPOINT ["/entrypoint.sh"]

