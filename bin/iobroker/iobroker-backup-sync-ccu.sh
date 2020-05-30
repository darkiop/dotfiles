#!/bin/bash

rsync -avz --exclude=*.tar.gz ~/docker/prod/iobroker-master/opt-iobroker/backups/test/ /mnt/odin/backup/ccu
