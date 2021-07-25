#!/bin/bash

DATE=$(date +%Y%m%d_%H%M%S)
MNT="/mnt/odin/backup"
BACKUP_OBJECTS="/etc/bind/ /var/cache/bind/"
BACKUP_TARGET="/home/darkiop/backups/bind9"
BACKUPS=`find $BACKUP_TARGET -name "bind9-*.gz" | wc -l | sed 's/\ //g'`
KEEP=8
IOB_SIMPLEAPI_DOMAIN="pve-vm-iobroker"
IOB_SIMPLEAPI_PORT="8087"
OID_EMAIL_TITLE="javascript.0.System.SendeTextperEmailBetreff"
OID_EMAIL_TEXT="javascript.0.System.SendeTextperEmail"
EMAIL_TITLE="bind9%20backup"
EMAIL_TEXT_TRUE=$EMAIL_TITLE"%20ausgefuehrt"
EMAIL_TEXT_FALSE=$EMAIL_TITLE"%20konnte%20nicht%20ausgefuehrt%20werden"

function targzobjects() {
  tar czf $BACKUP_TARGET/bind9-$DATE.tar.gz $BACKUP_OBJECTS
}

function rsynctotarget() {
  rsync -avz --delete $BACKUP_TARGET $MNT
}

function cleanup() {
  while [ $BACKUPS -ge $KEEP ]
  do
    ls -tr1 $BACKUP_TARGET/bind9-*.gz | head -n 1 | xargs rm -f 
    echo "deleting old backup files [$BACKUPS] ..."
    BACKUPS=`expr $BACKUPS - 1` 
  done
}

# check mountpoint
if mountpoint -q $MNT
then
  # mountpoint exists, run rsync
  cleanup
  targzobjects
  rsynctotarget
  sleep 2
  curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TITLE?value=$EMAIL_TITLE >/dev/null 2>&1
  sleep 2
  curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TEXT?value=$EMAIL_TEXT_TRUE >/dev/null 2>&1
else
  # try to mount
  mount $MNT
  # check mountpoint again
  if mountpoint -q $MNT
  then
    # mountpoint exists, run rsync
    cleanup
    targzobjects
    rsynctotarget
  else
    # exit
    curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TITLE?value=$EMAIL_TITLE >/dev/null 2>&1
    sleep 2
    curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TEXT?value=$EMAIL_TEXT_FALSE >/dev/null 2>&1
    exit 0
  fi
fi

# EOF