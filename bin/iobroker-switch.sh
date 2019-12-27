#!/bin/bash

# load colors
blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# switch directory
cd /opt/iobroker

echo "type '2.1.1' or another tagged version or 'github' for the last commited version from github"
read -p "switch js-controller to: " version
read -p "run fix.sh before install? (y/n)" fixsh

# Run fix.sh
if [ $fix == "y" ]; then
   curl -sL https://iobroker.net/fix.sh | bash -
fi

# Install
if [ $version != "github" ]; then
   
  # use killskript ('iobroker stop' do not work if not started with 'iobroker start')
  echo -e $red_color"ioBroker is terminated ..."$close_color
  pgrep -f '^io.*' | xargs kill -9
  sleep 1

  # install with npm + version
  echo -e $green_color"Install js-controller 1.5.14 ..."$close_color
  sudo -H -u iobroker npm install iobroker.js-controller@$version

  # start iobroker
  sleep 1
  echo -e $green_color"ioBroker will be started ..."$close_color
  iobroker start

  # wait 30s
  sleep 30

  # reload bash and show ioBroker Proceses in motd
  source ~/.bashrc

elif [ $version == "github" ]; then

  # use killskript ('iobroker stop' do not work if not started with 'iobroker start')
  echo -e $red_color"ioBroker is terminated ..."$close_color
  pgrep -f '^io.*' | xargs kill -9
  sleep 1
  
  # install from github
  echo -e $green_color"Install js-controller from Github ..."$close_color
  sleep 1
  sudo -H -u iobroker npm install ioBroker/ioBroker.js-controller
  
  # start iobroker
  sleep 1
  echo -e $green_color"ioBroker will be started ..."$close_color
  iobroker start

  # wait 30s
  sleep 30

  # reload bash and show ioBroker Proceses in motd
  source ~/.bashrc

else 
  echo "Version nicht korrekt."
fi

# EOF
