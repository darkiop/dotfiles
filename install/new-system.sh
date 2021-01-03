#!/bin/bash
#
# install curl and execute
# -> curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/bin/new-debian.sh | bash -

# set colors
blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# ask functions
ask() {
  local color="$1"
  case $color in
    green)
    color=$green_color
    ;;
    blue)
    color=$blue_color
    ;;
    lightblue)
    color=$light_blue_color
    ;;
    yellow)
    color=$yellow_color
    ;;
    red)
    color=$yellow_color
    ;;
  esac
  while true; do
    echo -e "$color"
    read -p "$2 ([y]/n) " -r
    echo -e "$close_color"
    REPLY=${REPLY:-"y"}
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      return 1
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      return 0
    fi
  done
}

# info function
infomsg() {
  local color="$1"
  case $color in
    green)
    color=$green_color
    ;;
    blue)
    color=$blue_color
    ;;
    lightblue)
    color=$light_blue_color
    ;;
    yellow)
    color=$yellow_color
    ;;
    red)
    color=$yellow_color
    ;;
  esac
  echo -e "$color"
  echo "$2"
  echo -e "$close_color"
}

# system updates
infomsg blue "update the system ..."
apt update
apt upgrade -y

# install sudo & git
infomsg blue "install git, curl and wget ..."
apt install -y sudo git curl wget

# time & locales
infomsg blue "setup timezone & locales ..."
apt-get install -y tzdata
ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo "Europe/Berlin" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
echo 'LANG="de_DE.UTF-8"'>/etc/default/locale
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=de_DE.UTF-8

# add user darkiop
infomsg blue "adduser: darkiop"
useradd -m -s /bin/bash darkiop
passwd darkiop

# add user darkiop to group sudo
infomsg blue "install git, curl and wget ..."
usermod -a -G sudo darkiop

# install samba
infomsg blue "install samba ..."
apt install -y samba-common samba

cat <<EOF > /etc/samba/smb.conf
[global]
  log file = /var/log/samba/log.%m
  logging = file
  map to guest = Bad User
  max log size = 1000
  obey pam restrictions = Yes
  pam password change = Yes
  panic action = /usr/share/samba/panic-action %d
  passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
  passwd program = /usr/bin/passwd %u
  server role = standalone server
  unix password sync = Yes
  usershare allow guests = Yes
  idmap config * : backend = tdb

[homes]
  browseable = No
  comment = Home Directories
  create mask = 0700
  directory mask = 0700
  read only = No
  valid users = %S
EOF

# add samba user
infomsg blue "set a password for sambauser ..."
smbpasswd -a darkiop

# restart smb service
infomsg blue "restart samba service ..."
systemctl restart smbd.service

# switch user
su darkiop