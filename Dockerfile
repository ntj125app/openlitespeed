FROM litespeedtech/openlitespeed:1.6.21-lsphp74

ADD composer-setup.sh /tmp/composer-setup.sh

ENV TINI_VERSION=v0.19.0
ENV DOCKERIZE_VERSION=v0.6.1

RUN apt-get update && apt-get install -y wget unzip language-pack-en-base language-pack-id-base && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "id_ID.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && apt-get clean && \
    chmod a+x /tmp/composer-setup.sh && \
    /tmp/composer-setup.sh && \
    wget -O /sbin/tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 && \
    chmod +x /sbin/tini && \
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN ln -sf /proc/self/fd/1 /usr/local/lsws/logs/localhost.access.log && \
    ln -sf /proc/self/fd/2 /usr/local/lsws/logs/error.log

ENTRYPOINT ["/sbin/tini", "-g", "--", "dockerize", "/entrypoint.sh"]