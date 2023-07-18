ARG PY_VERSION=3.11

FROM python:$PY_VERSION-slim

LABEL maintainer="Kirill Klenov <horneds@gmail.com>"

ARG BUILD_DATE

# Labels.
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-url="https://github.com/klen/muffin-docker"

# Install dependencies
RUN apt-get update && apt-get -y install --no-install-recommends \
  curl \
  git \
  make \
  && rm -rf /var/lib/apt/lists/*

# Install python dependencies
COPY ./requirements-build.txt /requirements-build.txt
RUN /usr/local/bin/pip install --no-cache-dir -r /requirements-build.txt

# Copy start script
COPY ./start.sh /start.sh

# Copy default application
COPY ./app /app

# Setup env
WORKDIR /app
EXPOSE 80
HEALTHCHECK --interval=1m --timeout=5s --start-period=30s --retries=3 CMD curl -f http://localhost || exit 1

# Run cmd
CMD ["/start.sh"]
