FROM litespeedtech/openlitespeed
RUN apt-get update && apt-get install -y language-pack-nl-base && \
    locale-gen && apt-get clean