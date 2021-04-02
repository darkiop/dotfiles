#!/bin/bash

# iobroker infos
if [ -f $(which iobroker) ]; then
  # get version
  iobversion=$(iobroker version)
  # get host info
  jscontroller_alive_state=$(iobroker state getvalue system.host.pve-vm-iobroker.alive | tail -n 1)
  if [ $jscontroller_alive_state == 'true' ]; then
    jscontroller_alive_state=$green_color'alive'
  elif [ $jscontroller_alive_state == 'false' ]; then
    jscontroller_alive_state=$red_color'alive'
  fi
    echo
    echo -e $light_blue_color"pve-vm-iobroker js-controller: $green_color$iobversion$close_color / $jscontroller_alive_state"$close_color
fi

# iobroker process-check
echo
numberofprocesses=$(iobroker list instances | grep enabled | wc -l)
echo -e $light_blue_color"ioBroker instances ("$numberofprocesses")"$green_color
processList=(
  "iobroker.js-controller" 
  "io.admin.0" 
  "io.backitup.0" 
  "io.bring.0" 
  "io.fritzbox.0" 
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
  "io.nina.0" 
  "io.node-red.0" 
  "io.onkyo.0" 
  "io.pi-hole.0" 
  "io.ping.0" 
  "io.robonect.0" 
  "io.scenes.0" 
  "io.shelly.0" 
  "io.simple-api.0" 
  "io.sourceanalytix.0" 
  "io.spotify-premium.0" 
  "io.sql.0" 
  "io.stiebel-isg.0" 
  "io.tankerkoenig.0" 
  "io.telegram.0" 
  "io.text2command.0" 
  "io.tr-064-community.0" 
  "io.web.0" 
  "io.wlanthermo-nano.0"
)

services=${#processList[@]}

echo
for (( i=0; i<${services}; i++)); do
if [ "$(pidof ${processList[$i]})" ]; then
  state="$green_color[Running]$close_color"
else
  state="$red_color[Stopped]$close_color"
fi
echo -e "$state ${processList[$i]}"
done

#EOF