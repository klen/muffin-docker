FROM horneds/muffin:py39

LABEL maintainer="Kirill Klenov <horneds@gmail.com>"

ARG BUILD_DATE

# Labels.
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-url="https://github.com/klen/muffin-docker"

ARG NODE_VERSION=14.17.3

# Install nodejs
RUN apt-get update && \
    apt-get -y install --no-install-recommends xz-utils curl && cd /opt && \
    curl https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz -O && \
    tar -xf node-v$NODE_VERSION-linux-x64.tar.xz && \
    ln -s /opt/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /opt/node-v$NODE_VERSION-linux-x64/bin/npm /usr/local/bin/npm && \
    ln -s /opt/node-v$NODE_VERSION-linux-x64/bin/npx /usr/local/bin/npx && \
    npm i -g npm@^7 && \
    rm -rf /var/lib/apt/lists/*
