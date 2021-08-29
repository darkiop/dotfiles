#!/bin/bash

# load colors
COLOR_BLUE="\e[38;5;33m"
COLOR_LIGHT_BLUE="\e[38;5;39m"
COLOR_RED="\e[38;5;196m"
COLOR_GREEN="\e[38;5;42m"
COLOR_GREEN_BOLD="\e[1;38;5;42m"
COLOR_YELLOW="\e[38;5;227m"
COLOR_CLOSE="$(tput sgr0)"

# switch directory
cd /opt/iobroker

echo "type '2.1.1' or another tagged version or 'github' for the last commited version from github"
read -p "switch js-controller to: " version
read -p "run fix.sh before install? (y/n): " fixsh

# run fix.sh
if [ $fixsh == "y" ]; then

  if pgrep -n iobroker >/dev/null 2>&1 || pgrep -n io. >/dev/null 2>&1; then
    echo -e $COLOR_RED"ioBroker will be terminated ..."$COLOR_CLOSE
    pgrep -f '^io.*' | xargs kill -9 >/dev/null 2>&1
    sleep 5
  fi
  
  if pgrep -n iobroker >/dev/null 2>&1 || pgrep -n io. >/dev/null 2>&1; then
    echo -e $COLOR_RED"done."$COLOR_CLOSE
  fi
  
  echo -e $COLOR_GREEN"run fix.sh ..."$COLOR_CLOSE
  curl -sL https://iobroker.net/fix.sh | bash -
  echo
fi

# install
if [ $version != "github" ]; then
   
  # use killskript ('iobroker stop' do not work if not started with 'iobroker start')

  if pgrep -n iobroker >/dev/null 2>&1 || pgrep -n io. >/dev/null 2>&1; then
    echo -e $COLOR_RED"ioBroker will be terminated ..."$COLOR_CLOSE
    pgrep -f '^io.*' | xargs kill -9 >/dev/null 2>&1
    sleep 5
  fi

  # install with npm + version
  echo -e $COLOR_GREEN"Install js-controller "$version " ..."$COLOR_CLOSE
  sudo -H -u iobroker npm install iobroker.js-controller@$version

  # start iobroker
  sleep 1
  echo -e $COLOR_GREEN"ioBroker will be started ..."$COLOR_CLOSE
  iobroker start

  # wait 30s
  sleep 30

  # reload bash and show ioBroker Proceses in motd
  source ~/.bashrc

elif [ $version == "github" ]; then

  if pgrep -n iobroker >/dev/null 2>&1 || pgrep -n io. >/dev/null 2>&1; then
    echo -e $COLOR_RED"ioBroker will be terminated ..."$COLOR_CLOSE
    pgrep -f '^io.*' | xargs kill -9 >/dev/null 2>&1
    sleep 5
  fi
  
  # install from github
  echo -e $COLOR_GREEN"Install js-controller from Github ..."$COLOR_CLOSE
  sleep 1
  sudo -H -u iobroker npm install ioBroker/ioBroker.js-controller
  
  # start iobroker
  sleep 1
  echo -e $COLOR_GREEN"ioBroker will be started ..."$COLOR_CLOSE
  iobroker start

  # wait 30s
  sleep 30

  # reload bash and show ioBroker Proceses in motd
  source ~/.bashrc

#else 
#  echo "Version nicht korrekt."
fi

# EOF
