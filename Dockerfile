FROM debian:10-slim

ENV TINI_VERSION=v0.19.0

COPY ./lsws-conf /lsws-conf
COPY ./comodo /comodo
COPY ./entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get install -y tini locales wget cron pkg-config && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "id_ID.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | bash && \
    apt-get update && apt-get install -y openlitespeed lsphp80 lsphp80-apcu lsphp80-apcu-dbgsym lsphp80-common lsphp80-curl lsphp80-dbg lsphp80-dev lsphp80-igbinary lsphp80-igbinary-dbgsym lsphp80-imap lsphp80-intl lsphp80-ldap lsphp80-memcached lsphp80-memcached-dbgsym lsphp80-modules-source lsphp80-msgpack lsphp80-msgpack-dbgsym lsphp80-mysql lsphp80-opcache lsphp80-pear lsphp80-pgsql lsphp80-pspell lsphp80-snmp lsphp80-sqlite3 lsphp80-sybase lsphp80-tidy && \
    ln -sf /usr/bin/tini /sbin/tini && \
    ln -sf /bin/sed /usr/bin/sed && \
    ln -sf /usr/local/lsws/lsphp80/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp && \
    ln -sf /usr/local/lsws/lsphp80/bin/php /usr/bin/php && \
    ln -sf /usr/local/lsws/lsphp80/bin/pecl /usr/bin/pecl && \
    ln -sf /usr/local/lsws/lsphp80/bin/pear /usr/bin/pear && \
    rm -rf /usr/local/lsws/conf && \
    mv /lsws-conf /usr/local/lsws/conf && \
    mkdir -p /usr/local/lsws/modsec && \
    mv /comodo /usr/local/lsws/modsec && \/comodo && \
    chown lsadm:lsadm -R /usr/local/lsws/conf && \
    chown lsadm:lsadm -R /usr/local/lsws/modsec/comodo && \
    pecl channel-update pecl.php.net && \
    pecl install redis && \
    echo "extension=redis.so" >> /usr/local/lsws/lsphp80/etc/php/8.0/litespeed/php.ini && \
    chmod a+x /entrypoint.sh && \
    apt-get clean

ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]