FROM almalinux:9

RUN dnf update -y && dnf install -y epel-release && dnf config-manager --set-enabled crb && \
    dnf install -y glibc-all-langpacks procps pkg-config gcc gcc-c++ make autoconf rcs glibc && \
    # LSWS DEPS
    curl https://repo.litespeed.sh | bash && \
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm && \
    dnf install -y fontconfig freetype libX11 libXext libXrender libjpeg libpng xorg-x11-fonts-75dpi xorg-x11-fonts-Type1 libnsl aspell && \
    dnf install -y http://rpms.litespeedtech.com/centos/9/x86_64/RPMS/ols-modsecurity-1.7.18-1.el9.x86_64.rpm && \
    dnf install -y lsphp82 lsphp82-common lsphp82-devel lsphp82-curl lsphp82-dbg lsphp82-imap lsphp82-intl lsphp82-ldap lsphp82-opcache lsphp82-mysqlnd lsphp82-pgsql lsphp82-mbstring lsphp82-pspell lsphp82-snmp lsphp82-sqlite3 lsphp82-gd lsphp82-xml lsphp82-process lsphp82-sodium && \
    dnf clean all
    # REDIS MAKE
RUN curl https://pecl.php.net/get/redis-6.0.2.tgz --output /redis-6.0.2.tgz && \
    cd / && \
    tar -zxvf /redis-6.0.2.tgz && \
    cd /redis-6.0.2 && \
    /usr/local/lsws/lsphp82/bin/phpize && \
    ./configure --enable-redis --with-php-config=/usr/local/lsws/lsphp82/bin/php-config && \
    make install && \
    rm -r /redis-6.0.2 && \
    rm -r /redis-6.0.2.tgz && \
    dnf clean all
    # EXCIMER MAKE
RUN curl https://pecl.php.net/get/excimer-1.1.1.tgz --output /excimer-1.1.1.tgz && \
    cd / && \
    tar -zxvf /excimer-1.1.1.tgz && \
    cd /excimer-1.1.1 && \
    /usr/local/lsws/lsphp82/bin/phpize && \
    ./configure --enable-excimer --with-php-config=/usr/local/lsws/lsphp82/bin/php-config && \
    make install && \
    rm -r /excimer-1.1.1 && \
    rm -r /excimer-1.1.1.tgz && \
    dnf clean all
    # IMAGE OPTIMIZERS
RUN dnf autoremove -y glibc-all-langpacks procps pkg-config gcc gcc-c++ make autoconf rcs && \
    dnf autoremove -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm && \
    dnf autoremove -y epel-release && \
    dnf clean all

COPY ./lsws-conf /lsws-conf
COPY ./rules /rules
COPY ./entrypoint.sh /entrypoint.sh
COPY ./20-redis.ini /20-redis.ini
COPY ./20-excimer.ini /20-excimer.ini
COPY ./mem-limit.ini /mem-limit.ini
COPY ./max-file-upload.ini /max-file-upload.ini

    # LSWS PREP
RUN ln -sf /usr/local/lsws/lsphp82/bin/php /usr/bin/php && \
    mv /usr/local/lsws/conf /usr/local/lsws/conf-disabled && \
    mv /lsws-conf /usr/local/lsws/conf && \
    mkdir -p /usr/local/lsws/modsec && \
    mv /rules /usr/local/lsws/modsec/rules && \
    chown lsadm:lsadm -R /usr/local/lsws/conf && \
    chown lsadm:lsadm -R /usr/local/lsws/modsec/rules && \
    mv /mem-limit.ini /usr/local/lsws/lsphp82/etc/php.d/mem-limit.ini && \
    mv /max-file-upload.ini /usr/local/lsws/lsphp82/etc/php.d/max-file-upload.ini && \
    mv /20-redis.ini /usr/local/lsws/lsphp82/etc/php.d/20-redis.ini && \
    mv /20-excimer.ini /usr/local/lsws/lsphp82/etc/php.d/20-excimer.ini && \
    chmod a+x /entrypoint.sh

WORKDIR /var/www/vhosts/localhost

ENTRYPOINT ["/entrypoint.sh"]

