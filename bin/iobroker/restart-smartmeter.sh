#!/bin/bash

if [ "$HOSTNAME" = pve-ct-iobroker ]; then

  echo "hostname = pve-ct-iobroker"

  ssh darkiop@loki bash -c "'sudo /usr/bin/systemctl restart ser2net.service'"

  sudo systemctl restart socat-loki-usb0.service
  sudo systemctl restart socat-loki-usb1.service

  sleep 5

  iobroker restart smartmeter.0
  iobroker restart smartmeter.1

else

  echo "hostname != pve-ct-iobroker"

  ssh darkiop@loki bash -c "'sudo /usr/bin/systemctl restart ser2net.service'"

  ssh darkiop@pve-ct-iobroker bash -c "'sudo systemctl restart socat-loki-usb0.service'"
  ssh darkiop@pve-ct-iobroker bash -c "'sudo systemctl restart socat-loki-usb1.service'"

  sleep 5

  ssh darkiop@pve-ct-iobroker bash -c "'iobroker restart smartmeter.0'"
  ssh darkiop@pve-ct-iobroker bash -c "'iobroker restart smartmeter.1'"

fi

# EOF