ARG PY_VERSION=3.13

FROM horneds/muffin:py$PY_VERSION as base

LABEL maintainer="Kirill Klenov <horneds@gmail.com>"

ARG BUILD_DATE

# Labels.
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-url="https://github.com/klen/muffin-docker"

# Install nodejs
FROM base as builder

ARG NODE_VERSION=18.16.1

RUN apt-get update && \
  apt-get -y install xz-utils && \
  curl https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz -O && \
  tar -xf node-v$NODE_VERSION-linux-x64.tar.xz

FROM base as deploy

ARG NODE_VERSION=18.16.1

COPY --from=builder /app/node-v$NODE_VERSION-linux-x64 /opt/node
RUN ln -sf /opt/node/bin/node /usr/local/bin/node && \
  ln -sf /opt/node/bin/npm /usr/local/bin/npm && \
  ln -sf /opt/node/bin/npx /usr/local/bin/npx
