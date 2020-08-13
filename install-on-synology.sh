#!/bin/bash
#
# manual install on synology dsm (no git)

dotfiles=/var/services/homes/darkiop/dotfiles



rm $dotfiles/install-on-synology.sh
wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/install-synology.sh -O $dotfiles/install-on-synology.sh

mkdir $dotfiles/motd
rm $dotfiles/motd/motd.sh
wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/motd/motd.sh -O $dotfiles/motd/motd.sh

rm $dotfiles/motd/motd-odin.sh
wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/motd/motd-odin.sh -O $dotfiles/motd/motd-odin.sh

mkdir $dotfiles/shells
rm $dotfiles/shells/alias
wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias -O $dotfiles/shells/alias

rm $dotfiles/shells/alias-docker
wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias-docker -O $dotfiles/shells/alias-docker

mkdir $dotfiles/bin
rm $dotfiles/bin/unifi-backup.sh
wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/bin/unifi-backup.sh -O $dotfiles/bin/unifi-backup.sh

# EOF
