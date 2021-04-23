#!/bin/bash
# CheckMK-Documentation: https://docs.checkmk.com/latest/de/localchecks.html
# /usr/lib/check_mk_agent/local
#
#                  |----| |---------| |--------------| |-----------------------------------------|
# example output: "STATUS SERVICENAME METRICS=73;80;90 STATUS DETAIL TEXT WHICH CAN CONTAIN SPACES"
#
# Status: 0 = OK | 1 = WARN | 2 = CRIT | 3 = UNKNOWN | P = dynamic

# ioBroker Processes
#iobProcess=$(/usr/bin/ps -o cmd -C "node" --no-headers | grep ^iobroker.js-controller 1>&2 | echo $?)
iobProcess=$(pidof iobroker.js-controller)
if [ "$?" -ne 0 ]; then
  status=2
  statusdetail='not running'
else
  status=0
  statusdetail='running'
fi
servicename='ioBroker.js-controller'
metrics='-'
echo "$status $servicename $metrics $statusdetail"

# ioBroker Status
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

# number of processes
# TODO metrics
iobNumberOfProcesses=$(/usr/bin/ps -o cmd -C "node" --no-headers | wc -l)
status=0
servicename='ioBroker.NumberOfProcesses'
metrics='-'
statusdetail=$iobNumberOfProcesses
echo "$status $servicename $metrics $statusdetail"

# ioBroker getvalue
# TODO metrics
# TODO error handling (iobroker is not runnig)
iobGetvalue=$(iobroker state getvalue smartmeter.1.1-0:16_7_0__255.value)
if [[ $iobGetvalue -gt 400 && $iobGetvalue -lt 1000 ]]; then
  status=1
elif [ "$iobGetvalue" -ge "1000" ]; then
  status=2
else
  status=0
fi
servicename='ioBroker.GetValueTest'
metrics='-'
statusdetail=$iobGetvalue
echo "$status $servicename $metrics $statusdetail"

# EOF