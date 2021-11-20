#!/bin/bash

tail -fn0 /opt/iobroker/log/iobroker.current.log | \
while read line ; do
  echo "$line" | grep "No or too long answer from Serial Device after last request"
  if [ $? = 0 ]; then
    /usr/bin/ssh darkiop@loki bash -c "'sudo /usr/sbin/reboot -f'"
  fi
done