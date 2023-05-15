#!/bin/bash

lock_file=$XMLTV_FOLDER/cron.lock

if [ -z "$CRON_EXPRESSION" ]; then
    echo "CRON_EXPRESSION not set. Exiting..."
    exit 1
fi

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

crontab_file="$CRONTAB_FILE"
cron_expression="$CRON_EXPRESSION"
grabber="$GRABBER"

grabber_args=""

if [ ! -z "$CONFIG_FILE" ]; then
    grabber_args="$grabber_args --config-file \"$CONFIG_FILE\""
else
    echo "CONFIG_FILE not set. Exiting..."
    exit 1
fi

if [ ! -z "$OUTPUT" ]; then
    grabber_args="$grabber_args --output \"$OUTPUT\""
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
cron_line="$cron_expression flock -w 0 $lock_file $command_line"

echo "Using the following cron expression: $cron_expression"
echo "Using the following command line: $command_line"
echo "Using the following lock file: $lock_file"
echo "Creating crontab \"$crontab_file\"..."
echo "$cron_line > /proc/1/fd/1 2>&1" >$crontab_file
chmod 0644 $crontab_file
crontab $crontab_file

echo "Starting cron..."
cron -f
