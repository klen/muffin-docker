#! /usr/bin/env sh
set -e

if [ -f /app/app.py ]; then
    DEFAULT_MODULE_NAME=app
elif [ -f /app/main.py ]; then
    DEFAULT_MODULE_NAME=main
elif [ -f /app/app/app.py ]; then
    DEFAULT_MODULE_NAME=app.app
elif [ -f /app/app/main.py ]; then
    DEFAULT_MODULE_NAME=app.main
fi
MODULE_NAME=${MODULE_NAME:-$DEFAULT_MODULE_NAME}
VARIABLE_NAME=${VARIABLE_NAME:-"app"}

export APP_MODULE=${APP_MODULE:-"$MODULE_NAME:$VARIABLE_NAME"}
export SETUP_SCRIPT=${SETUP_SCRIPT:-"/app/setup.sh"}

export HOST=${HOST:-"0.0.0.0"}
export PORT=${PORT:-"80"}
export GWORKER_CLASS=${GWORKER_CLASS:-"uvicorn.workers.UvicornWorker"}
export GWORKERS=${GWORKERS:-`nproc --all`}
export GBIND=${GBIND:-"$HOST:$PORT"}
export GLOG_LEVEL=${GLOG_LEVEL:-"info"}

# Check for 'setup.sh' script
if [ -f $SETUP_SCRIPT ]; then
    . $SETUP_SCRIPT
fi

echo "Start application"
/usr/local/bin/gunicorn "$APP_MODULE" \
    --workers "$GWORKERS" \
    --worker-class "$GWORKER_CLASS" \
    --log-level "$GLOG_LEVEL" \
    --bind="$GBIND" $GARGS
