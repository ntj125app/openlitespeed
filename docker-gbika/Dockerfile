ARG BASEIMAGE

# Base Image
FROM ${BASEIMAGE} AS base

ARG PHP_VERSION
ARG LS_VERSION
ARG PHP_DETAIL_VERSION

RUN rm -f /usr/local/lsws/modsec/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf

COPY ./rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf /usr/local/lsws/modsec/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf

RUN cat /usr/local/lsws/modsec/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf | grep "REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf" && \
    ls -lah /usr/local/lsws/modsec/rules

# Check PHP Version
RUN php -v && \
    php -m
