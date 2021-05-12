#!/bin/bash
# CheckMK-Documentation: https://docs.checkmk.com/latest/de/localchecks.html
# Installation (on client): /usr/lib/check_mk_agent/local
#
#           |----| |---------| |--------------| |-----------------------------------------|
# Example  "STATUS SERVICENAME METRICS=73;80;90 STATUS DETAIL TEXT WHICH CAN CONTAIN SPACES"
# Status:  0 = OK | 1 = WARN | 2 = CRIT | 3 = UNKNOWN | P = dynamic
# Metrics: metrics=value;warn;crit;min;max

#
# ioBroker Status
#
iobStatus=$(iobroker status | head -n1)
if [[ $iobStatus == *"not"* ]]; then
  status=2
else
  status=0
fi
servicename='ioBroker.Status'
metrics='-'
statusdetail=$iobStatus
echo "$status $servicename $metrics $statusdetail"

# EOF