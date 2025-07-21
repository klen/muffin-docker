ARG PY_VERSION=3.13

FROM python:$PY_VERSION-slim

LABEL maintainer="Kirill Klenov <horneds@gmail.com>"

ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-url="https://github.com/klen/muffin-docker"

# Install runtime deps only (no compiler)
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential curl gcc git \
  && rm -rf /var/lib/apt/lists/*

COPY ./requirements-build.txt .
RUN pip install -r requirements-build.txt

COPY ./start.sh /start.sh
COPY ./app /app

WORKDIR /app
EXPOSE 80

HEALTHCHECK --interval=1m --timeout=5s --start-period=30s --retries=3 \
  CMD curl -f http://localhost || exit 1

CMD ["/start.sh"]
