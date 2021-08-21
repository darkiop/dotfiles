#!/bin/bash

# iobroker infos
if [ -f $(which iobroker) ]; then
  # get version
  iobversion=$(iobroker version)
  npmversion=$(npm -v)
  nodeversion=$(node -v)
  # get host info
  jscontroller_alive_state=$(iobroker state getvalue system.host.pve-vm-iobroker.alive | tail -n 1)
  if [ $jscontroller_alive_state == 'true' ]; then
    jscontroller_alive_state=$COLOR_GREEN'alive'
  elif [ $jscontroller_alive_state == 'false' ]; then
    jscontroller_alive_state=$COLOR_RED'alive'
  fi
    echo
    echo -e $COLOR_LIGHT_BLUE"js-controller: "$COLOR_GREEN$iobversion$COLOR_CLOSE / $jscontroller_alive_state$COLOR_CLOSE
    echo -e $COLOR_LIGHT_BLUE"node: "$COLOR_GREEN$nodeversion$COLOR_CLOSE
    echo -e $COLOR_LIGHT_BLUE"npm: "$COLOR_GREEN$npmversion$COLOR_CLOSE
    echo
fi

# iobroker process-check
#numberofprocesses=$(iobroker list instances | grep enabled | wc -l)
#echo -e $COLOR_LIGHT_BLUE"ioBroker instances ("$numberofprocesses")"$COLOR_GREEN
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
#  state="$COLOR_GREEN[Running]$COLOR_CLOSE"
#else
#  state="$COLOR_RED[Stopped]$COLOR_CLOSE"
#fi
#echo -e "$state ${processList[$i]}"
#done

#EOF