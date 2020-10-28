FROM litespeedtech/openlitespeed
RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    apt-get install rbenv libreadline-dev ruby-dev -y && \
    rbenv install 2.7.2 && \
    rbenv global 2.7.2 && \
    gem install rack -v 2.2.3 && \
    gem install ruby-lsapi && \
    gem install rails && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn nodejs && \
    apt-get clean