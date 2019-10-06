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
echo -e "$blue_color"special aliases"$close_color   `echo -e "$green_color"iobl"$close_color"`"

# iobroker version
if [ -f $(which iobroker) ]; then
  iobversion=$(iobroker version)
  echo
  echo -e $light_blue_color"ioBroker js-controller: $green_color$iobversion$close_color"
fi

# iobroker process-check
echo
echo -e $light_blue_color"ioBroker instances:"$green_color

process=("iobroker.js-controller" "io.admin.0" "io.backitup.0" "io.bring.0" "io.harmony.0" "io.hm-rega.0" "io.hm-rpc.1" "io.hm-rpc.2" "io.hs100.0" "io.hue.0" "io.info.0" "io.javascript.0" "io.javascript.1" "io.moma.0" "io.mqtt.0" "io.pi-hole.0" "io.ping.0" "io.simple-api.0" "io.sql.0" "io.stiebel-isg.0" "io.tankerkoenig.0" "io.telegram.0" "io.text2command.0" "io.tr-064-community.0" "io.web.0" "io.wlanthermo.0")
name=("iobroker.js-controller" "io.admin.0" "io.backitup.0" "io.bring.0" "io.harmony.0" "io.hm-rega.0" "io.hm-rpc.1" "io.hm-rpc.2" "io.hs100.0" "io.hue.0" "io.info.0" "io.javascript.0" "io.javascript.1" "io.moma.0" "io.mqtt.0" "io.pi-hole.0" "io.ping.0" "io.simple-api.0" "io.sql.0" "io.stiebel-isg.0" "io.tankerkoenig.0" "io.telegram.0" "io.text2command.0" "io.tr-064-community.0" "io.web.0" "io.wlanthermo.0")
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

#EOF