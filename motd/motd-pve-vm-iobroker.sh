#!/bin/bash

# iobroker infos
if [ -f $(which iobroker) ]; then
  
  iobversion=$(iobroker version)
  npmversion=$(npm -v)
  nodeversion=$(node -v)
  
  iobservice="$(systemctl is-active iobroker.service)"
  if [ $iobservice = "active" ]; then
    iobservice=$COLOR_GREEN'active'
  elif [ $iobservice == 'inactive' ]; then
    iobservice=$COLOR_RED'inactive'
  elif [ $iobservice == 'failed' ]; then
    iobservice=$COLOR_RED'failed'
  fi

  echo
  echo -e "" $COLOR_LIGHT_BLUE"js-controller: "$COLOR_GREEN$iobversion$COLOR_CLOSE / $iobservice$COLOR_CLOSE
  echo -e "" $COLOR_LIGHT_BLUE"node: "$COLOR_GREEN$nodeversion$COLOR_CLOSE
  echo -e "" $COLOR_LIGHT_BLUE"npm: "$COLOR_GREEN$npmversion$COLOR_CLOSE
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