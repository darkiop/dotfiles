#!/bin/bash
#
# Kopiert iobroker Backups nach NFS Mount /mnt/odin/backup/iobroker
# fstab: 192.168.1.43:/volume1/backup /mnt/odin/backup nfs rw 0 0
# crontab: 30 4 * * * /home/darkiop/dotfiles/bin/iobroker/iobroker-backup-sync-grafana.sh

MNT="/mnt/odin/backup"
BACKUPS="/opt/iobroker/backups/"
RSYNC="sudo rsync -avz --exclude=homematic_*  --exclude=mysql_* --exclude=javascripts_* --exclude=iobroker_* --exclude=redis*  --exclude=*-migration --delete $BACKUPS $MNT/grafana"
IOB_SIMPLEAPI_DOMAIN="pve-vm-iobroker"
IOB_SIMPLEAPI_PORT="8087"
OID_EMAIL_TITLE="javascript.0.System.SendeTextperEmailBetreff"
OID_EMAIL_TEXT="javascript.0.System.SendeTextperEmail"
EMAIL_TITLE="ioBroker%20Backup%20(grafana)"
EMAIL_TEXT_TRUE="iobroker-backup-sync-grafana.sh%20wurde%20ausgefuehrt"
EMAIL_TEXT_FALSE="iobroker-backup-sync-grafana.sh%20konnte%20nicht%20ausgefuehrt%20werden"

# check mountpoint
if mountpoint -q $MNT
then
  # mountpoint exists, run rsync
  $RSYNC
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
    $RSYNC
  else
    # exit
    curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TITLE?value=$EMAIL_TITLE >/dev/null 2>&1
    sleep 2
    curl http://$IOB_SIMPLEAPI_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TEXT?value=$EMAIL_TEXT_FALSE >/dev/null 2>&1
    exit 0
  fi
fi

# EOF