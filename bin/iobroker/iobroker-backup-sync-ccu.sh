#!/bin/bash

rsync -avz --exclude=*.tar.gz ~/docker/prod/iobroker-master/opt-iobroker/backups/ /mnt/odin/backup/ccu
