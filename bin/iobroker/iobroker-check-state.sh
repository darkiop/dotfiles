#!/bin/bash

if [[ $(iobroker status) = *not* ]]; then

  echo "ioBroker muss neu gestartet werden"
  echo "$(date '+%Y-%m-%d %H:%M:%S') ioBroker Prozess ist nicht aktiv, wird neu gestartet" >> /opt/iobroker-master/check_iobroker.log
  echo "Stoppe alle noch laufenden ioBroker Prozesse ..."
  pgrep -f '^io.*' | xargs kill -9
  sleep 5
  echo "Starte ioBroker neu:"
  sudo -u iobroker /usr/bin/node /opt/iobroker/node_modules/iobroker.js-controller/controller.js > /opt/scripts/iobroker.log 2>&1 &

else

  echo "ioBroker muss nicht neu gestartet werden"
  #echo "$(date '+%Y-%m-%d %H:%M:%S') ioBroker Prozess ist aktiv" >> /opt/iobroker/check_iobroker.log

fi

#EOF
