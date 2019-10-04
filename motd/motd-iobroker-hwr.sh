#!/bin/bash

# load colors
blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# show alias in motd
echo -e "$blue_color"special aliases"$close_color   `echo -e "$green_color"iob-log"$close_color"`"

# process-check
process=("iobroker.js-controller" "io.smartmeter.0" "io.smartmeter.1")
name=("iobroker.js-controller" "io.smartmeter.0" "io.smartmeter.1")
services=${#process[@]}

echo
for (( i=0; i<${services}; i++)); do
if [ "$(pidof ${process[$i]})" ]; then
  state="$green_color[Running]$close_color"
else
  state="$red_color[Stopped]$close_color"
fi
echo -e "$state ${name[$i]}"
done
echo

#EOF