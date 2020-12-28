#!/bin/bash

# show alias in motd
echo -e "$blue_color"special aliases"$close_color   `echo -e "$green_color"iobl"$close_color"`"

# iobroker version
if [ -f $(which iobroker) ]; then
  iobversion=$(iobroker version)
  echo
  echo -e $light_blue_color"ioBroker js-controller: $green_color$iobversion$close_color"
fi

# iobroker process-check
echo
echo -e $light_blue_color"iobroker instances:"$green_color

process=(
  "iobroker.js-controller" 
  "io.smartmeter.0" 
  "io.smartmeter.1"
)

services=${#process[@]}

echo
for (( i=0; i<${services}; i++)); do
if [ "$(pidof ${process[$i]})" ]; then
  state="$green_color[Running]$close_color"
else
  state="$red_color[Stopped]$close_color"
fi
echo -e "$state ${process[$i]}"
done

#EOF