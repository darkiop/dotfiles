#!/bin/bash
# CheckMK-Documentation: https://docs.checkmk.com/latest/de/localchecks.html
# Installation (on client): /usr/lib/check_mk_agent/local
#
#           |----| |---------| |--------------| |-----------------------------------------|
# Example  "STATUS SERVICENAME METRICS=73;80;90 STATUS DETAIL TEXT WHICH CAN CONTAIN SPACES"
# Status:  0 = OK | 1 = WARN | 2 = CRIT | 3 = UNKNOWN | P = dynamic
# Metrics: metrics=value;warn;crit;min;max

#
# number of processes
#
NumberOfProcesses=$(/usr/bin/ps -o cmd -C "node" --no-headers | wc -l)
status=P
servicename='ioBroker.NumberOfProcesses'
metrics="count=$NumberOfProcesses;10;5;;"
statusdetail=$NumberOfProcesses
echo "$status $servicename $metrics $statusdetail"

#
# number of updates
#
NumberOfUpdates=$(iobroker update | grep Updateable | wc -l)
status=P
servicename='ioBroker.NumberOfUpdates'
metrics="count=$NumberOfUpdates;16;20;;"
statusdetail='number of updates'
echo "$status $servicename $metrics $statusdetail"

# EOF