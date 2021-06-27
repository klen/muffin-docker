FROM python:3.7-slim

LABEL maintainer="Kirill Klenov <horneds@gmail.com>"

ARG BUILD_DATE

# Labels.
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-url="https://github.com/klen/muffin-docker"

# Install system dependencies
RUN apt-get update && apt-get -y install --no-install-recommends \
        build-essential \
        curl \
        gnupg2 \
        libncurses5-dev \
        wget && \
    rm -rf /var/lib/apt/lists/*

# Install python dependencies
RUN /usr/local/bin/pip install --no-cache-dir \
    wheel==0.36.2 \
    gunicorn==20.1.0 \
    uvicorn[standard]==0.14.0 \
    psycopg2-binary==2.9.1 \
    PyJWT==2.1.0 \
    ipython==7.25.0 \
    muffin==0.83.0

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
