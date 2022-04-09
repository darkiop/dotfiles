#!/bin/bash

DATE=$(date +%Y-%m-%d_%H:%M:%S)
LOGFILE="/var/log/wg-check-ip.log"
DYNDNS="xxxxxxxxxxxxxxxxxxxx"
IP1=$(wg | grep endpoint | awk '{print $2}' | sed 's/:.*//')
IP2=$(nslookup $DYNDNS | grep -A2 Name | grep Address | awk '{print $2}' | tail -n1)

if [ "$IP1" != "$IP2" ]; then
  systemctl restart wg-quick@wg0.service
  echo $DATE" - IP "$DYNDNS" <> wg0-endpoint - restart wg-quick@wg0.service"
  echo $DATE" - IP "$DYNDNS" <> wg0-endpoint - restart wg-quick@wg0.service" >> ${LOGFILE}
else
  echo $IP1 "=" $IP2 " nothing todo"
fi