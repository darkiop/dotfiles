#!/bin/bash

DATE=$(date +%Y-%m-%d_%H:%M:%S)
LOGFILE="/var/log/wg-check-birkenweg.log"

IP1=$(wg | grep endpoint | awk '{print $2}' | sed 's/:.*//')
IP2=$(nslookup birkenweg.walk-steinweiler.de | grep -A2 Name | grep Address | awk '{print $2}')

if [ "$IP1" != "$IP2" ]; then
  systemctl restart wg-quick@wg0.service
  echo $DATE" - IP of birkenweg.walk-steinweiler.de != wg0-endpoint - restart wg-quick@wg0.service" >> ${LOGFILE}
fi