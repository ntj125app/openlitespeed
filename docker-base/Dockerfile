FROM litespeedtech/openlitespeed:latest

RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get install -y curl wget && \
    apt-get autoclean -y && \
    mv /usr/local/lsws/conf /usr/local/lsws/conf-disabled && \
    rm /entrypoint.sh

COPY ./lsws-conf /usr/local/lsws/conf

RUN chown lsadm:lsadm -R /usr/local/lsws/conf

COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /var/www/vhosts/localhost

ENTRYPOINT ["/entrypoint.sh"]
