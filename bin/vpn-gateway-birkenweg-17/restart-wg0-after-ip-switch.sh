#!/bin/bash

DATE=$(date +%Y-%m-%d_%H:%M:%S)
LOGFILE="/var/log/wg-check-endpoint.log"
DYNDNS=""

IP1=$(wg | grep endpoint | awk '{print $2}' | sed 's/:.*//')
IP2=$(nslookup $DYNDNS | grep -A2 Name | grep Address | awk '{print $2}')

if [ "$IP1" != "$IP2" ]; then
  systemctl restart wg-quick@wg0.service
  echo $DATE" - IP of $DYNDNS != IP wg0-endpoint - restart wg-quick@wg0.service" >> ${LOGFILE}
fi