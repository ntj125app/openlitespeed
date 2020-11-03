FROM litespeedtech/openlitespeed
RUN apt-get update && apt-get install -y language-pack-en-base language-pack-id-base && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "id_ID.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && apt-get clean