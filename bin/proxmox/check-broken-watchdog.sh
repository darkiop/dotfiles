#!/bin/bash

# check if root
if [ "${EUID}" -ne 0 ]; then
  echo "You need to run this as root. Exit."
  exit 1
fi

# check if dategrep is installed
if [ ! $(which dategrep) ]; then
  echo "dategrep not found. Exit."
  exit 1
fi

GREP=$(dategrep --last-minutes 3 /var/log/syslog | grep 'Broken pipe' | wc -l)
MAX=10

if [ $GREP -gt ${MAX} ]; then

  echo "trying to stop PVE services ..."
  systemctl stop pve-cluster
  systemctl stop pvedaemon
  systemctl stop pvestatd
  systemctl stop pveproxy

  echo "killing running LXCs & VMs ..."
  pgrep lxc-start | xargs kill -9
  pgrep kvm | xargs kill -9

  echo "reboot ..."
  reboot

fi