#!/bin/bash
#
# Kopiert iobroker-mariadb Backups nach NFS Mount /mnt/odin/backup/iobroker-mariadb
# fstab: 192.168.1.43:/volume1/backup /mnt/odin/backup nfs rw 0 0
# crontab: 30 4 * * * /home/darkiop/dotfiles/bin/iobroker/iobroker-backup-sync-iobroker-mariadb.sh

# check mountpoint
if mountpoint -q /mnt/odin/backup
then
  # run rsync
  sudo rsync -avz --exclude=homematic_* --exclude=iobroker_* --delete /home/darkiop/docker/prod/iobroker-master/opt-iobroker/backups/ /mnt/odin/backup/iobroker-mariadb
  curl http://$IOBROKER_DOMAIN:8087/set/javascript.0.System.SendeTextperEmail?value=hallo%20hallo234
else
  # mount
  mount /mnt/odin/backup
  # check again
  if mountpoint -q /mnt/odin/backup
  then
    # run rsync
    sudo rsync -avz --exclude=homematic_* --exclude=iobroker_* --delete /home/darkiop/docker/prod/iobroker-master/opt-iobroker/backups/ /mnt/odin/backup/iobroker-mariadb
  else
    # exit
    exit 0
  fi
fi

# EOF
