#!/bin/bash

if [ ! -z "$GRABBER" ]; then

    # Validade grabber aginst a list of available grabbers
    tv_find_grabbers | grep -q "$GRABBER"
    if [ $? -ne 0 ]; then
        echo "GRABBER \"$GRABBER\" not found. Heres a list of available XMLTV grabbers..."
        tv_find_grabbers
        exit 1
    fi

else
    echo "GRABBER not set. Heres a list of available XMLTV grabbers..."
    tv_find_grabbers
    exit 1
fi

grabber="$GRABBER"

grabber_args=""

if [ ! -z "$CONFIG_FILE" ]; then
    grabber_args="$grabber_args --config-file \"$CONFIG_FILE\""
else
    echo "CONFIG_FILE not set. Exiting..."
    exit 1
fi

if [ ! -z "$OUTPUT" ]; then
    grabber_args="$grabber_args --output \"$OUTPUT.tmp\""
else
    echo "OUTPUT not set. Exiting..."
    exit 1
fi

if [ ! -z "$DAYS" ]; then
    grabber_args="$grabber_args --days $DAYS"
fi

if [ ! -z "$OFFSET" ]; then
    grabber_args="$grabber_args --offset $OFFSET"
fi

if [ ! -z "$GRABBER_ARGS" ]; then
    grabber_args="$grabber_args $GRABBER_ARGS"
fi

command_line="$grabber$grabber_args"

echo "Using the following command line: $command_line"
