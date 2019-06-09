#!/bin/bash

LOAD_1min=$(cat /proc/loadavg | cut -d " " -f1)
LOAD_5min=$(cat /proc/loadavg | cut -d " " -f2)
LOAD_15min=$(cat /proc/loadavg | cut -d " " -f3)

curl http://[HOSTNAME]:8087/set/javascript.0.Netzwerk.freya.load1?value=$LOAD_1min
curl http://[HOSTNAME]:8087/set/javascript.0.Netzwerk.freya.load5?value=$LOAD_5min
curl http://[HOSTNAME]:8087/set/javascript.0.Netzwerk.freya.load15?value=$LOAD_15min
