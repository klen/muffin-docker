FROM muffin:py37

LABEL maintainer="Kirill Klenov <horneds@gmail.com>"

ARG BUILD_DATE

# Labels.
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-url="https://github.com/klen/muffin-docker"

# Install nodejs
RUN echo "deb https://deb.nodesource.com/node_14.x buster main" > /etc/apt/sources.list.d/nodesource.list && \
    wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
        nodejs=$(apt-cache show nodejs|grep Version|grep nodesource|cut -c 10-)  && \
    apt-mark hold nodejs && \
    npm i -g npm@^7 && \
    rm -rf /var/lib/apt/lists/*

