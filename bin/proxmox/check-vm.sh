#!/bin/bash

# -------------------------------------------------------------
# check if user is root and if not exit
# -------------------------------------------------------------
function check_if_user_is_root() {
  if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this as root. Exit."
    exit 1
  fi
}

check_if_user_is_root

if [ "$#" -ne 2 ]; then
  echo "Usage: check-vm.sh <VM-ID> <VM-IP>"
  exit 1
fi

VM=$1
IP=$2

ping -c 1 $IP &> /dev/null && echo "Ping OK - VM $VM" || /usr/sbin/qm stop $VM && /usr/sbin/qm start $VM && echo "No response: Restarting VM $VM"