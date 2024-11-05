#!/bin/bash

# init PID
pid=0

# SIGTERM signal handlers
sigterm_handler() {
    if [ $pid -ne 0 ]; then
        kill -s SIGTERM $pid
        wait $pid
    fi
    exit 143; # 128 + 15 -- SIGTERM
}

# CTRL + C signal handlers
abort_handler() {
    if [ $pid -ne 0 ]; then
        kill -s SIGTERM $pid
        wait $pid
    fi
    exit 130; # 128 + 2 -- SIGINT
}

trap 'sigterm_handler' SIGTERM
trap 'abort_handler' SIGINT INT

# run application if no ARGS / CMD
if [ $# -eq 0 ]; then
    /usr/local/lsws/bin/litespeed
else
    exec "$@"
fi

# container healthcheck
while true; do
    if [ $# -eq 0 ]; then
        if ! /usr/local/lsws/bin/lswsctrl status | grep 'litespeed is running' > /dev/null; then
            /usr/local/lsws/bin/lswsctrl status >&1
            exit 143; # 128 + 15 -- SIGTERM
        fi
    fi

    # prevent container from exiting and get stdout
    tail -f /usr/local/lsws/logs/main.log >&1 &
    wait ${!}
done
