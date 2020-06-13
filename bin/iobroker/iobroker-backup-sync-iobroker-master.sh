#!/bin/bash
#
# Kopiert iobroker-master Backups nach NFS Mount /mnt/odin/backup/iobroker-master
# fstab: 192.168.1.43:/volume1/backup /mnt/odin/backup nfs rw 0 0
# crontab: 30 4 * * * /home/darkiop/dotfiles/bin/iobroker/iobroker-backup-sync-iobroker-master.sh

IOBROKER_DOMAIN="iobroker-master"

# check mountpoint
if mountpoint -q /mnt/odin/backup
then
  # mountpoint exists, run rsync
  sudo rsync -avz --exclude=mysql_* --exclude=homematic_* --delete /home/darkiop/docker/prod/iobroker-master/opt-iobroker/backups/ /mnt/odin/backup/iobroker-master
  sleep 5
  curl http://$IOBROKER_DOMAIN:8087/set/javascript.0.System.SendeTextperEmailBetreff?value=ioBroker%20Backup
  sleep 5
  curl http://$IOBROKER_DOMAIN:8087/set/javascript.0.System.SendeTextperEmail?value=iobroker/iobroker-backup-sync-iobroker-master.sh%20wurde%20ausgefuehrt
else
  # try to mount
  mount /mnt/odin/backup
  # check mountpoint again
  if mountpoint -q /mnt/odin/backup
  then
    # mountpoint exists, run rsync
    sudo rsync -avz --exclude=mysql_* --exclude=homematic_* --delete /home/darkiop/docker/prod/iobroker-master/opt-iobroker/backups/ /mnt/odin/backup/iobroker-master
  else
    # exit
    curl http://$IOBROKER_DOMAIN:8087/set/javascript.0.System.SendeTextperEmailBetreff?value=ioBroker%20Backup
    sleep 5
    curl http://$IOBROKER_DOMAIN:8087/set/javascript.0.System.SendeTextperEmail?value=iobroker/iobroker-backup-sync-iobroker-master.sh%20konnte%20nicht%20ausgefuehrt%20werden
    sleep 5
    exit 0
  fi
fi

# EOF
