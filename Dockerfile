FROM ghcr.io/ntj125app/openlitespeed:php82

    #PHP Version
ENV PHP_VERSION 8.3.3
ENV PHP_MAJOR_VERSION 8.3
ENV LSPHP_VERSION lsphp83

    #INSTALL DEPENDENCIES
RUN apt-get install -y build-essential pkg-config openssl libssl-dev bison autoconf automake libtool re2c flex libxml2-dev libssl-dev libbz2-dev libcurl4-openssl-dev libjpeg-dev libfreetype6-dev libgmp3-dev libc-client2007e-dev libldap2-dev libmcrypt-dev libmhash-dev freetds-dev zlib1g-dev libmariadb-dev-compat libmariadb-dev libncurses5-dev libpcre3-dev libaspell-dev libreadline-dev librecode-dev libsnmp-dev libtidy-dev libxslt1-dev libbz2-dev libcurl4-openssl-dev libffi-dev libzip-dev libpng-dev libjpeg-dev libwebp-dev libavif-dev libgmp-dev libldap2-dev libonig-dev libssl-dev libpq-dev libreadline-dev libsodium-dev libxml2-dev libzip-dev libkrb5-dev libsqlite3-dev libenchant-2-dev libxpm-dev libsasl2-dev freetds-dev libpspell-dev libedit-dev libargon2-dev && \
    dpkg -L freetds-dev | grep libsybdb.a | xargs -i ln -s {} /usr/lib && \
    curl https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz --output /php-${PHP_VERSION}.tar.gz && \
    cd / && \
    tar -xf /php-${PHP_VERSION}.tar.gz && \
    cd /php-${PHP_VERSION} && \
    #CONFIGURE (Command copied from existing build)
    ./configure --prefix=/usr/local/lsws/${LSPHP_VERSION} --enable-cgi --enable-cli --enable-phpdbg=no --enable-litespeed --with-config-file-path=/usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/litespeed/ --with-config-file-scan-dir=/usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/mods-available/ --build=x86_64-linux-gnu --host=x86_64-linux-gnu --libdir=${prefix}/lib/php --libexecdir=${prefix}/lib/php --datadir=${prefix}/share/php/${PHP_MAJOR_VERSION} --program-suffix=${PHP_MAJOR_VERSION} --disable-all --disable-debug --disable-rpath --disable-static --with-pic --with-layout=GNU --without-pear --enable-bcmath --enable-calendar --enable-ctype --enable-dom --with-enchant --enable-exif --with-gettext --with-gmp --enable-fileinfo --enable-filter --enable-ftp --enable-hash --with-iconv --enable-mbregex --enable-mbregex-backtrack --enable-mbstring --enable-phar --enable-posix --enable-mysqlnd-compression-support --with-zlib --with-openssl=yes --with-libedit --with-libxml --with-bz2 --enable-session --enable-simplexml --enable-soap --enable-sockets --enable-tokenizer --enable-xml --enable-xmlreader --enable-xmlwriter --with-xmlrpc --with-xsl --with-mhash=yes --enable-sysvmsg --enable-sysvsem --enable-sysvshm --with-zip --with-sodium --with-password-argon2 --with-system-tzdata --enable-gd --enable-gd-native-ttf --with-jpeg --with-xpm --with-png --with-webp --with-freetype --with-vpx-dir --with-mysql-sock=/var/run/mysqld/mysqld.sock --disable-dtrace --enable-pdo --enable-mysqlnd --enable-pcntl --with-curl=shared,/usr --with-imap=shared,/usr --with-kerberos --with-imap-ssl=yes --enable-intl=shared --with-ldap=shared,/usr --with-ldap-sasl=/usr --with-mysqli=shared,mysqlnd --with-pdo-mysql=shared,mysqlnd --with-pgsql=shared,/usr --with-pdo-pgsql=shared,/usr --with-pspell=shared,/usr --with-snmp=shared,/usr --with-sqlite3=shared,/usr --with-pdo-sqlite=shared,/usr --with-pdo-dblib=shared,/usr --with-tidy=shared,/usr --enable-opcache --enable-opcache-file --enable-huge-code-pages build_alias=x86_64-linux-gnu host_alias=x86_64-linux-gnu CFLAGS="-g -O2 -ffile-prefix-map=/build/php${PHP_MAJOR_VERSION}-${PHP_VERSION}=. -fstack-protector-strong -Wformat -Werror=format-security -O2 -Wall -fsigned-char -fno-strict-aliasing -fno-lto -g" && \
    make install -j$(nproc) && \
    mkdir -p /usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}

COPY ./litespeed /usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/litespeed
COPY ./mods-available /usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/mods-available

    #RELINK FILES
RUN mv /usr/local/lsws/${LSPHP_VERSION}/bin/lsphp${PHP_MAJOR_VERSION} /usr/local/lsws/${LSPHP_VERSION}/bin/lsphp && \
    cp /usr/local/lsws/${LSPHP_VERSION}/bin/php${PHP_MAJOR_VERSION} /usr/local/lsws/${LSPHP_VERSION}/bin/php && \
    cp /usr/local/lsws/${LSPHP_VERSION}/bin/php-config${PHP_MAJOR_VERSION} /usr/local/lsws/${LSPHP_VERSION}/bin/php-config && \
    cp /usr/local/lsws/${LSPHP_VERSION}/bin/phpize${PHP_MAJOR_VERSION} /usr/local/lsws/${LSPHP_VERSION}/bin/phpize && \
    ln -sf /usr/local/lsws/${LSPHP_VERSION}/bin/php /usr/bin/php && \
    sed -i "s/lsphp\([0-9]\{2\}\)\/bin\/lsphp/${LSPHP_VERSION}\/bin\/lsphp/g" /usr/local/lsws/conf/httpd_config.conf

COPY ./php.d/max-file-upload.ini /usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/mods-available/max-file-upload.ini
COPY ./php.d/mem-limit.ini /usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/mods-available/mem-limit.ini

    # REDIS MAKE
RUN curl https://pecl.php.net/get/redis-6.0.2.tgz --output /redis-6.0.2.tgz && \
    cd / && \
    tar -zxf /redis-6.0.2.tgz && \
    cd /redis-6.0.2 && \
    /usr/local/lsws/${LSPHP_VERSION}/bin/phpize && \
    ./configure --enable-redis --with-php-config=/usr/local/lsws/${LSPHP_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /redis-6.0.2 && \
    rm -r /redis-6.0.2.tgz && \
    apt-get autoclean -y

COPY ./php.d/20-redis.ini /usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/mods-available/20-redis.ini

    # EXCIMER MAKE
RUN curl https://pecl.php.net/get/excimer-1.1.1.tgz --output /excimer-1.1.1.tgz && \
    cd / && \
    tar -zxf /excimer-1.1.1.tgz && \
    cd /excimer-1.1.1 && \
    /usr/local/lsws/${LSPHP_VERSION}/bin/phpize && \
    ./configure --enable-excimer --with-php-config=/usr/local/lsws/${LSPHP_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /excimer-1.1.1 && \
    rm -r /excimer-1.1.1.tgz && \
    apt-get autoclean -y

COPY ./php.d/20-excimer.ini /usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/mods-available/20-excimer.ini

    # XDEBUG MAKE (Need a PHP version >= 7.2.0 and < 8.2.0 (found 8.3.3))
#RUN curl https://xdebug.org/files/xdebug-3.1.1.tgz --output /xdebug-3.1.1.tgz && \
#    cd / && \
#    tar -zxf /xdebug-3.1.1.tgz && \
#    cd /xdebug-3.1.1 && \
#    /usr/local/lsws/${LSPHP_VERSION}/bin/phpize && \
#    ./configure --enable-xdebug --with-php-config=/usr/local/lsws/${LSPHP_VERSION}/bin/php-config && \
#    make install -j$(nproc) && \
#    rm -r /xdebug-3.1.1 && \
#    rm -r /xdebug-3.1.1.tgz && \
#    apt-get autoclean -y
#
#COPY ./php.d/99-xdebug.ini /usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/mods-available/99-xdebug.ini

    # PCOV MAKE
RUN curl https://pecl.php.net/get/pcov-1.0.11.tgz --output /pcov-1.0.11.tgz && \
    cd / && \
    tar -zxf /pcov-1.0.11.tgz && \
    cd /pcov-1.0.11 && \
    /usr/local/lsws/${LSPHP_VERSION}/bin/phpize && \
    ./configure --enable-pcov --with-php-config=/usr/local/lsws/${LSPHP_VERSION}/bin/php-config && \
    make install -j$(nproc) && \
    rm -r /pcov-1.0.11 && \
    rm -r /pcov-1.0.11.tgz && \
    apt-get autoclean -y

COPY ./php.d/99-pcov.ini /usr/local/lsws/${LSPHP_VERSION}/etc/php/${PHP_MAJOR_VERSION}/mods-available/99-pcov.ini

    # REPLACE LSPHP in OLS SERVER

    # CHECK IF PHP INSTALLED CORRECTLY
RUN php -v && \
    php -m && \
    php -i