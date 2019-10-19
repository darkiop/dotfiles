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

# iobroker infos
if [ -f $(which iobroker) ]; then
  
  # get version
  iobversion=$(iobroker version)
  
  # get host info
  jscontroller_iobroker_master_alive=$(iobroker state getvalue system.host.iobroker-master.alive | tail -n 1)
  #jscontroller_iobroker_hwr_alive=$(iobroker state getvalue system.host.iobroker-hwr.alive | tail -n 1)
  
  # iobroker-master
  if [ $jscontroller_iobroker_master_alive == 'true' ]; then
    jscontroller_iobroker_master_alive=$green_color'alive'
  elif [ $jscontroller_iobroker_master_alive == 'false' ]; then
    jscontroller_iobroker_master_alive=$red_color'alive'
  fi
  
  # iobroker-hwr
  #if [ $jscontroller_iobroker_hwr_alive == 'true' ]; then
  #  jscontroller_iobroker_hwr_alive=$green_color'alive'
  #else
  #  jscontroller_iobroker_hwr_alive=$red_color'alive'
  #fi
  
  echo
  echo -e $light_blue_color"iobroker-master js-controller: $green_color$iobversion$close_color / $jscontroller_iobroker_master_alive"$close_color
  #echo -e $light_blue_color"iobroker-hwr js-controller: $green_color$iobversion$close_color / $jscontroller_iobroker_hwr_alive"$close_color

fi

# iobroker process-check
echo
echo -e $light_blue_color"ioBroker instances:"$green_color

process=(
  "iobroker.js-controller" 
  "io.admin.0" 
  "io.backitup.0" 
  "io.bring.0" 
  "io.harmony.0" 
  "io.hm-rega.0" 
  "io.hm-rpc.1" 
  "io.hm-rpc.2" 
  "io.hs100.0" 
  "io.hue.0" 
  "io.info.0" 
  "io.javascript.0" 
  "io.javascript.1" 
  "io.mercedesme.0" 
  "io.mihome-vacuum.0" 
  "io.moma.0" 
  "io.mqtt.0" 
  "io.onkyo.0" 
  "io.pi-hole.0" 
  "io.ping.0" 
  "io.robonect.0" 
  "io.scenes.0" 
  "io.simple-api.0" 
  "io.sql.0" 
  "io.stiebel-isg.0" 
  "io.shelly.0" 
  "io.spotify-premium.0" 
  "io.telegram.0" 
  "io.tankerkoenig.0" 
  "io.text2command.0" 
  "io.tr-064-community.0" 
  "io.web.0" 
  "io.wlanthermo.0"
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