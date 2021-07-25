#!/bin/bash

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="bind9"
BACKUP_COMPLETE_NAME="$BACKUP_NAME-$DATE"
BACKUP_OBJECTS="/etc/bind/ /var/cache/bind/"
BACKUP_LOCAL_TARGET="/home/darkiop/backups/$BACKUP_NAME"
BACKUP_RSYNC_TARGET="/mnt/odin/backup"
BACKUPS=`find $BACKUP_LOCAL_TARGET -name "bind9-*.gz" | wc -l | sed 's/\ //g'`
KEEP=50
IOB_SIMPLEAPI_DOMAIN="pve-vm-iobroker"
IOB_SIMPLEAPI_PORT="8087"
OID_EMAIL_TITLE="javascript.0.System.SendeTextperEmailBetreff"
OID_EMAIL_TEXT="javascript.0.System.SendeTextperEmail"
EMAIL_TITLE="bind9%20backup"
EMAIL_TEXT_TRUE=$EMAIL_TITLE"%20ausgefuehrt"
EMAIL_TEXT_FALSE=$EMAIL_TITLE"%20konnte%20nicht%20ausgefuehrt%20werden"

function targz_to_local_target() {
  tar czf $BACKUP_LOCAL_TARGET/$BACKUP_COMPLETE_NAME.tar.gz $BACKUP_OBJECTS
}

function rsync_to_rsync_target() {
  rsync -avz --delete $BACKUP_LOCAL_TARGET $BACKUP_RSYNC_TARGET
}

function cleanup() {
  while [ $BACKUPS -ge $KEEP ]
  do
    ls -tr1 $BACKUP_LOCAL_TARGET/$BACKUP_NAME-*.gz | head -n 1 | xargs rm -f 
    echo "deleting old backup files [$BACKUPS] ..."
    BACKUPS=`expr $BACKUPS - 1` 
  done
}

function send_email_with_iobroker() {
  echo "test"
}

# check mountpoint
if mountpoint -q $BACKUP_RSYNC_TARGET
then
  # mountpoint exists, run rsync
  cleanup
  targz_to_local_target
  rsync_to_rsync_target
  sleep 2
  curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TITLE?value=$EMAIL_TITLE >/dev/null 2>&1
  sleep 2
  curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TEXT?value=$EMAIL_TEXT_TRUE >/dev/null 2>&1
else
  # try to mount
  mount $BACKUP_RSYNC_TARGET
  sleep 2
  # check mountpoint again
  if mountpoint -q $BACKUP_RSYNC_TARGET
  then
    # mountpoint exists, run rsync
    cleanup
    targz_to_local_target
    rsync_to_rsync_target
  else
    # exit
    curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TITLE?value=$EMAIL_TITLE >/dev/null 2>&1
    sleep 2
    curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TEXT?value=$EMAIL_TEXT_FALSE >/dev/null 2>&1
    exit 0
  fi
fi

# EOF