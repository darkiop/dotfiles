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
#echo
#numberofprocesses=$(iobroker list instances | grep enabled | wc -l)
#echo -e $light_blue_color"ioBroker instances ("$numberofprocesses")"$green_color
#
#processList=(
#  "system.adapter.hs100.0.alive",
#  "system.adapter.telegram.0.alive"
#)
#
#services=${#processList[@]}
#
#echo
#for (( i=0; i<${services}; i++)); do
#if [ "$(iobroker state getvalue ${processList[$i]} | tail -n 1)" ]; then
#  state="$green_color[Running]$close_color"
#else
#  state="$red_color[Stopped]$close_color"
#fi
#echo -e "$state ${processList[$i]}"
#done

#EOF