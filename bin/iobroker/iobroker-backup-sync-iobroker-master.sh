#!/bin/bash
#
# Kopiert iobroker-master Backups nach NFS Mount /mnt/odin/backup/iobroker-master
# fstab: 192.168.1.43:/volume1/backup /mnt/odin/backup nfs rw 0 0
# crontab: 30 4 * * * /home/darkiop/dotfiles/bin/iobroker/iobroker-backup-sync-iobroker-master.sh

sudo rsync -avz --exclude=mysql_* --exclude=homematic_* --delete /home/darkiop/docker/prod/iobroker-master/opt-iobroker/backups/ /mnt/odin/backup/iobroker-master

# EOF
