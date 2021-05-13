#!/bin/bash
# CheckMK-Documentation: https://docs.checkmk.com/latest/de/localchecks.html
# Installation (on client): /usr/lib/check_mk_agent/local
#
#           |----| |---------| |--------------| |-----------------------------------------|
# Example  "STATUS SERVICENAME METRICS=73;80;90 STATUS DETAIL TEXT WHICH CAN CONTAIN SPACES"
# Status:  0 = OK | 1 = WARN | 2 = CRIT | 3 = UNKNOWN | P = dynamic
# Metrics: metrics=value;warn;crit;min;max

#
# ioBroker Process: iobroker.js-controller
#
iobProcess=$(pidof iobroker.js-controller)
#iobProcess=$(/usr/bin/ps -o cmd -C "node" --no-headers | grep ^iobroker.js-controller 1>&2 | echo $?)
if [ "$?" -ne 0 ]; then
  status=2
  statusdetail='not running'
else
  status=0
  statusdetail='running'
fi
servicename='ioBroker.iobroker.js-controller'
metrics='-'
echo "$status $servicename $metrics $statusdetail"

# EOF