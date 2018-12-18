#!/usr/bin/env bash

BINARY="python"
PARAMS="-m homeassistant --config /config"

######################################################

CMD=$1

if [[ -z "${CONFIG_LOG_TARGET}" ]]; then
  LOG_FILE="/dev/null"
else
  LOG_FILE="${CONFIG_LOG_TARGET}"
fi

case $CMD in

describe)
    echo "Sleep $PARAMS"
    ;;

## exit 0 = is not running
## exit 1 = is running
is-running)
    if pgrep -f "$BINARY $PARAMS" >/dev/null 2>&1 ; then
        exit 1
    fi
    exit 0
    ;;

start)
    echo "Starting... $BINARY $PARAMS" >> "$LOG_FILE"
    echo "Checking socat..."
    SOCATCHECK=`pgrep -f "socat"`
    if [ "${SOCATCHECK}" = "" ] >/dev/null 2>&1 ; then
        echo "##### socat is not running, skipping start of home assistant"
#        exit 1
    fi

    if [ "${MYSQL_HOST}" != "" ]; then
        echo "Checking mysql..."
        MYSQLCHECK=`mysql -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PASS} -e';'`
        if [ $? != 0 ]; then
            echo "##### MySQL is not running, skipping start of home assistant"
            exit 1
        fi
    fi

    if [ "${MQTT_HOST}" != "" ]; then
        echo "Checking mqtt..."
        MQTTCHECK=`mosquitto_pub -h ${MQTT_HOST} -u ${MQTT_USER} -P ${MQTT_PASS} -n -t /test`
        if [ $? != 0 ]; then
            echo "##### MQTT is not running, skipping start of home assistant"
            exit 1
        fi
    fi

    # Everything is running, start homeassistant
    cd /usr/src/app
    $BINARY $PARAMS 2>$LOG_FILE >$LOG_FILE &
    exit 0

    ;;

start-fail)
    echo "Start failed! $BINARY $PARAMS"
    ;;

stop)
    echo "Stopping... $BINARY $PARAMS"
    cd /usr/src/app
    kill -9 $(pgrep -f "$BINARY $PARAMS")
    ;;

esac