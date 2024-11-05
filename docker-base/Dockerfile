FROM debian:12-slim

# FOR DEBIAN CREATE GROUP ALIAS NOBODY FROM ALREADY EXISTING NOGROUP
RUN groupadd -o -g 65534 nobody

RUN apt-get update && apt-get install -y curl && \
    curl -o /lsup.sh https://raw.githubusercontent.com/litespeedtech/openlitespeed/master/dist/admin/misc/lsup.sh && \
    chmod +x /lsup.sh && \
    /lsup.sh && \
    apt-get autoclean -y

# UPDATE IMAGE
RUN apt-get upgrade -y && \
    apt-get autoclean -y

# LSWS PREP
RUN mv /usr/local/lsws/conf /usr/local/lsws/conf-disabled

COPY ./lsws-conf /usr/local/lsws/conf

RUN chown lsadm:lsadm -R /usr/local/lsws/conf

COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /var/www/vhosts/localhost

ENTRYPOINT ["/entrypoint.sh"]
