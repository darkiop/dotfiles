#!/bin/bash
#
# Kopiert CCU Backups nach NFS Mount /mnt/odin/backup/ccu
# fstab: 192.168.1.43:/volume1/backup /mnt/odin/backup nfs rw 0 0
# crontab: 30 4 * * * /home/darkiop/dotfiles/bin/iobroker/iobroker-backup-sync-ccu.sh

sudo rsync -avz --exclude=mysql_* --exclude=iobroker_* --delete /home/darkiop/docker/prod/iobroker-master/opt-iobroker/backups/ /mnt/odin/backup/ccu

# EOF