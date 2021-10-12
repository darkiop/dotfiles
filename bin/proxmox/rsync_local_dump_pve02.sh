#!/bin/bash
#
# 1 Uhr     / 7 Uhr     / 13 Uhr     / 19 Uhr
# 0 1 * * * / 0 7 * * * / 0 13 * * * / 0 19 * * *
#
# 0 19 * * * /root/dotfiles/bin/proxmox/rsync_local_dump_pve02.sh

BACKUP_NAME="local-dumps-pve02"
BACKUP_PATH_LOCAL="/var/lib/vz/dump/"
BACKUP_PATH_REMOTE="/mnt/pve/odin-pve/local-dump-rsync/pve02"

function check_if_user_is_root() {
  if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this as root. Exit."
    exit 1
  fi
}

function rsync_to_remote_path() {
  rsync -avz --delete $BACKUP_PATH_LOCAL $BACKUP_PATH_REMOTE
}

# check mountpoint
if [ -d /mnt/pve/odin-pve/local-dump-rsync ]
then
  # mountpoint exists, run rsync
  rsync_to_remote_path
  exit 0
else
  # try to mount
  mount $BACKUP_PATH_REMOTE
  sleep 2
  # check mountpoint again
  if mountpoint -q $BACKUP_PATH_REMOTE
  then
    # mountpoint exists, run rsync
    rsync_to_remote_path
    exit 0
  else
    exit 1
  fi
fi

# EOF