#!/bin/bash
#
# 1 Uhr     / 7 Uhr     / 13 Uhr     / 19 Uhr
# 0 1 * * * / 0 7 * * * / 0 13 * * * / 0 19 * * *
#
# 0 19 * * * /root/dotfiles/bin/backup/pve-ct-bind-master_rsync_to_odin.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_USER="darkiop"
BACKUP_GROUP="darkiop"
BACKUP_NAME="pve-ct-bind-slave"
BACKUP_NAME_DATE="$BACKUP_NAME-$DATE"
BACKUP_OBJECTS="/etc/bind/"
BACKUP_PATH_LOCAL="/home/darkiop/backups/$BACKUP_NAME"
BACKUP_PATH_REMOTE="/mnt/odin/backup"
BACKUP_FILES=`find $BACKUP_PATH_LOCAL -name "$BACKUP_NAME-*.gz" | wc -l | sed 's/\ //g'`
BACKUP_KEEP=8
IOB_DOMAIN="pve-vm-iobroker"
IOB_SIMPLEAPI_PORT="8087"
OID_EMAIL_TITLE="javascript.0.System.SendeTextperEmailBetreff"
OID_EMAIL_TEXT="javascript.0.System.SendeTextperEmail"
EMAIL_TITLE=$BACKUP_NAME"%20backup"
EMAIL_TEXT_TRUE=$EMAIL_TITLE"%20ausgefuehrt"
EMAIL_TEXT_FALSE=$EMAIL_TITLE"%20konnte%20nicht%20ausgefuehrt%20werden"

function check_if_user_is_root() {
  if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this as root. Exit."
    exit 1
  fi
}

function targz_to_local_path() {
  tar czf $BACKUP_PATH_LOCAL/$BACKUP_NAME_DATE.tar.gz $BACKUP_OBJECTS
  chown $BACKUP_USER:$BACKUP_GROUP $BACKUP_PATH_LOCAL/$BACKUP_NAME_DATE.tar.gz
}

function rsync_to_remote_path() {
  rsync -avz --delete $BACKUP_PATH_LOCAL $BACKUP_PATH_REMOTE
}

function cleanup() {
  while [ $BACKUP_FILES -ge $BACKUP_KEEP ]
  do
    ls -tr1 $BACKUP_PATH_LOCAL/$BACKUP_NAME-*.gz | head -n 1 | xargs rm -f 
    echo "deleting old backup files [$BACKUP_FILES] ..."
    BACKUP_FILES=`expr $BACKUP_FILES - 1` 
  done
}

function send_email_with_iobroker() {
  echo "test"
  # TODO email nur wenn false

  sleep 2
  curl http://$IOB_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TITLE?value=$EMAIL_TITLE > /dev/null 2>&1
  sleep 2
  curl http://$IOB_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TEXT?value=$EMAIL_TEXT_TRUE > /dev/null 2>&1

}

# check if local path exists, and if not create it
if [ ! -d $BACKUP_PATH_LOCAL ]; then
  mkdir $BACKUP_PATH_LOCAL
fi

# check mountpoint
if mountpoint -q $BACKUP_PATH_REMOTE
then
  # mountpoint exists, run rsync
  cleanup
  targz_to_local_path
  rsync_to_remote_path
  sleep 2
  curl http://$IOB_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TITLE?value=$EMAIL_TITLE > /dev/null 2>&1
  sleep 2
  curl http://$IOB_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TEXT?value=$EMAIL_TEXT_TRUE > /dev/null 2>&1
  exit 0
else
  # try to mount
  mount $BACKUP_PATH_REMOTE
  sleep 2
  # check mountpoint again
  if mountpoint -q $BACKUP_PATH_REMOTE
  then
    # mountpoint exists, run rsync
    cleanup
    targz_to_local_path
    rsync_to_remote_path
  else
    # exit
    curl http://$IOB_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TITLE?value=$EMAIL_TITLE > /dev/null 2>&1
    sleep 2
    curl http://$IOB_DOMAIN:$IOB_SIMPLEAPI_PORT/set/$OID_EMAIL_TEXT?value=$EMAIL_TEXT_FALSE > /dev/null 2>&1
    exit 1
  fi
fi

# EOF