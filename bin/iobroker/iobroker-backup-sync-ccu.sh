#!/bin/bash

sudo rsync -avz --exclude=mysql_* --exclude=iobroker_* --delete /home/darkiop/docker/prod/iobroker-master/opt-iobroker/backups/ /mnt/odin/backup/ccu

# EOF
