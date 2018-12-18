# Home Assistant with socat for remote zwave

Instead of using a locally-connected zwave device (usbstick/etc), we can use a serial device mapped over the network with ser2net or socat and then map it to a local zwave serial device with socat.

Please [report issues on github](https://github.com/peterforeman/homeassistant-socat/issues).

## Getting Started

This docker container ensures that:
 - socat is running
 - (optional) mysql is reachable
 - (optional) mqtt is reachable
 - homeassistant is running

If there are any failures, both socat and homeassistant will be restarted.

### Prerequisites

See the normal homeassistant docker container readme.

### Installing

The container needs some extra parameters as described below.

All [homeassistant-home-assistant](https://hub.docker.com/r/homeassistant/home-assistant/) image options are available and on top of that a few others have been added.

# Basic options

**DEBUG_VERBOSE**=0

Set to 1 to see more information
Default: 0

**PAUSE_BETWEEN_CHECKS**=2

In seconds, how much time to wait between checking running processes.
Default: 2

**LOG_TARGET**=/log.log

Path to log file. Omit to write logs to stdout.
Default: stdout

# Socat options

**SOCAT_ZWAVE_TYPE**="tcp"

**SOCAT_ZWAVE_HOST**="192.168.5.5"

**SOCAT_ZWAVE_PORT**="7676"

Where socat should connect to. Will be used as tcp://192.168.5.5:7676

**SOCAT_ZWAVE_LINK**="/dev/zwave"

What the zwave device should be mapped to. Use this in your homeassistant configuration file.

# MySQL options

**MYSQL_HOST**="1.2.3.4"

**MYSQL_USER**="user"

**MYSQL_PASS**="pass"

# MQTT options

**MQTT_HOST**="1.2.3.4"

**MQTT_USER**="user"

**MQTT_PASS**="pass"


## Deployment

Example socat on host system:
```
/usr/bin/socat /dev/zwave,b115200,rawer,echo=0 tcp-listen:7676,reuseaddr,su=nobody
```

Example zwave.service (debian systemd) on host system:
```
[Unit]
Description=zwave socat
After=network.target auditd.service

[Service]
ExecStart=/usr/bin/socat /dev/zwave,b115200,rawer,echo=0 tcp-listen:7676,reuseaddr,su=nobody
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=always
Type=simple

[Install]
WantedBy=multi-user.target
Alias=zwave.service
```

## Acknowledgements

Based on [homeassistant-home-assistant](https://hub.docker.com/r/homeassistant/home-assistant/) image, [published on docker hub](https://hub.docker.com/r/forepe/homeassistant-socat/).

Based on [vladbabii/homeassistant-socat](https://hub.docker.com/r/vladbabii/homeassistant-socat).
