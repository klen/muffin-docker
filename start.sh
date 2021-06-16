#! /usr/bin/env sh
set -e

if [ -f /app/app.py ]; then
    DEFAULT_MODULE_NAME=app
elif [ -f /app/main.py ]; then
    DEFAULT_MODULE_NAME=main
fi
MODULE_NAME=${MODULE_NAME:-$DEFAULT_MODULE_NAME}
VARIABLE_NAME=${VARIABLE_NAME:-app}

export APP_MODULE=${APP_MODULE:-"$MODULE_NAME:$VARIABLE_NAME"}
export WORKER_CLASS=${WORKER_CLASS:-"uvicorn.workers.UvicornWorker"}

echo "Start application"
/usr/local/bin/gunicorn "$APP_MODULE" -k "$WORKER_CLASS" --bind=0.0.0.0:80 $GARGS
