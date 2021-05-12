#!/bin/bash
# CheckMK-Documentation: https://docs.checkmk.com/latest/de/localchecks.html
# Installation (on client): /usr/lib/check_mk_agent/local
#
#           |----| |---------| |--------------| |-----------------------------------------|
# Example  "STATUS SERVICENAME METRICS=73;80;90 STATUS DETAIL TEXT WHICH CAN CONTAIN SPACES"
# Status:  0 = OK | 1 = WARN | 2 = CRIT | 3 = UNKNOWN | P = dynamic
# Metrics: metrics=value;warn;crit;min;max

#
# ioBroker Process: io.hm-rega.0
#
iobProcess=$(pidof io.hm-rega.0)
if [ "$?" -ne 0 ]; then
  status=2
  statusdetail='not running'
else
  status=0
  statusdetail='running'
fi
servicename='ioBroker.io.hm-rega.0'
metrics='-'
echo "$status $servicename $metrics $statusdetail"

#
# ioBroker Process: io.hm-rpc.1
#
iobProcess=$(pidof io.hm-rpc.1)
if [ "$?" -ne 0 ]; then
  status=2
  statusdetail='not running'
else
  status=0
  statusdetail='running'
fi
servicename='ioBroker.io.hm-rpc.1'
metrics='-'
echo "$status $servicename $metrics $statusdetail"

#
# ioBroker Process: io.smartmeter.0
#
iobProcess=$(pidof io.smartmeter.0)
if [ "$?" -ne 0 ]; then
  status=2
  statusdetail='not running'
else
  status=0
  statusdetail='running'
fi
servicename='ioBroker.io.smartmeter.0'
metrics='-'
echo "$status $servicename $metrics $statusdetail"

#
# ioBroker Process: io.smartmeter.1
#
iobProcess=$(pidof io.smartmeter.1)
if [ "$?" -ne 0 ]; then
  status=2
  statusdetail='not running'
else
  status=0
  statusdetail='running'
fi
servicename='ioBroker.io.smartmeter.1'
metrics='-'
echo "$status $servicename $metrics $statusdetail"

#
# ioBroker Process: io.javascript.0
#
iobProcess=$(pidof io.javascript.0)
if [ "$?" -ne 0 ]; then
  status=2
  statusdetail='not running'
else
  status=0
  statusdetail='running'
fi
servicename='ioBroker.io.javascript.0'
metrics='-'
echo "$status $servicename $metrics $statusdetail"

#
# ioBroker Process: io.stiebel-isg.0
#
iobProcess=$(pidof io.stiebel-isg.0)
if [ "$?" -ne 0 ]; then
  status=2
  statusdetail='not running'
else
  status=0
  statusdetail='running'
fi
servicename='ioBroker.io.stiebel-isg.0'
metrics='-'
echo "$status $servicename $metrics $statusdetail"

# EOF
