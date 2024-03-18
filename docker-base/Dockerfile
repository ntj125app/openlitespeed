FROM debian:12-slim

# FOR DEBIAN CREATE GROUP ALIAS NOBODY FROM ALREADY EXISTING NOGROUP
RUN groupadd -o -g 65534 nobody

COPY ./repo.litespeed.sh /repo.litespeed.sh

RUN apt-get update && apt-get install -y curl && \
    chmod +x /repo.litespeed.sh && \
    /repo.litespeed.sh && \
    apt-get install -y ols-modsecurity && \
    apt-get autoclean -y

# UPDATE IMAGE
RUN apt-get upgrade -y && \
    apt-get autoclean -y

# LSWS PREP
RUN mv /usr/local/lsws/conf /usr/local/lsws/conf-disabled

COPY ./lsws-conf /usr/local/lsws/conf

RUN mkdir -p /usr/local/lsws/modsec

COPY ./rules /usr/local/lsws/modsec/rules

RUN chown lsadm:lsadm -R /usr/local/lsws/conf && \
    chown lsadm:lsadm -R /usr/local/lsws/modsec/rules

COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /var/www/vhosts/localhost

ENTRYPOINT ["/entrypoint.sh"]
