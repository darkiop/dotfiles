#!/bin/bash

DATE=$(date +%Y-%m-%d_%H:%M:%S)
LOGFILE="/var/log/check_vm.log"

# check if root
if [ "${EUID}" -ne 0 ]; then
  echo "You need to run this as root. Exit."
  exit 1
fi

# usage
if [ "$#" -ne 2 ]; then
  echo "Usage: check-vm.sh <VM-ID> <VM-IP>"
  exit 1
fi

# validate vm-id
if [[ $1 =~ ((^[0-9]{3}$)) ]]; then
  VM=$1
else
  echo "Parameter 1 is not a VM-ID."
  exit 1
fi

# validate ip
if [[ $2 =~ (([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5]))$ ]]; then
  IP=$2
else
  echo "Parameter 2 is not a valid IP."
  exit 1
fi

# check vm with fping
fping -c1 -t1000 $IP &>/dev/null
if [ "$?" = 0 ]; then
  echo "VM $VM is online"
  echo $DATE" - VM $VM is online" >> ${LOGFILE}
else
  echo "VM $VM is offline. Restarting VM $VM"
  echo $DATE" - VM $VM offline. Restarting VM $VM" >> ${LOGFILE}
  /usr/sbin/qm stop $VM
  /usr/sbin/qm start $VM
fi

# EOF