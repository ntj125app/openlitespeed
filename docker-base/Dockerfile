FROM debian:12-slim

# FOR DEBIAN CREATE GROUP ALIAS NOBODY FROM ALREADY EXISTING NOGROUP
RUN groupadd -o -g 65534 nobody

# UPDATE IMAGE
RUN apt-get update -y

RUN apt-get install -y curl && \
    curl https://repo.litespeed.sh | bash && \
    apt-get install -y ols-modsecurity && \
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
