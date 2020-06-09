#!/bin/bash
# custom script for iobroker Container
# check if onkyo-eiscp is installed
# pip3 should be installed by docker run

if [ -f /usr/bin/pip3 ]; then
  if [ ! -f /usr/local/bin/onkyo ]; then
    pip3 install onkyo-eiscp
  fi
fi