#!/bin/bash

rsync -avz --exclude=mysql_* --exclude=iobroker_* /home/darkiop/docker/prod/iobroker-master/opt-iobroker/backups/ /mnt/odin/backup/ccu

# EOF
