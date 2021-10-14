#!/bin/bash
# https://github.com/fedya/omv_motd.git
# modified by thwalk

# uptime
UPTIME="$(/usr/bin/cut -d. -f1 /proc/uptime)"
UPTIME_SECONDS=$((${UPTIME}%60))
UPTIME_MIN=$((${UPTIME}/60%60))
UPTIME_HOURS=$((${UPTIME}/3600%24))
UPTIME_DAYS=$((${UPTIME}/86400))
UPTIME_TEXT=`printf "%d $UPTIME_DAYS, %02dh:%02dm:%02ds" "$UPTIME_DAYS" "$UPTIME_HOURS" "$UPTIME_MIN" "$UPTIME_SECONDS"`

# size of /
USAGE_ROOT=$(df -h / | awk '/\// {print $(NF-1)}' | sed 's/%//g')
USAGE_ROOT_GB=$(df -h / | awk '/\// {print $(NF-3)}')
USAGE_ROOT_TOTAL=$(df -h / | awk '/\// {print $(NF-4)}')

# home-size
HOME_USAGE=$(du -h | tail -n 1 | awk '{print $1}')

# get hostname
HOSTNAME=$(hostname)

# get os version & ip & cputemp
case $HOSTNAME in
  (odin)
    get_plat_data="Synology DSM "$(cat /etc.defaults/VERSION | grep productversion | awk -F'=' '{print $2}' | sed 's/"//' | sed 's/"//')
    get_cpu_temp=$(($(cat /sys/class/hwmon/hwmon0/temp1_input)/1000))"°C"
    get_ip_host=$(/sbin/ip -o -4 addr list ovs_eth0 | awk '{print $4}' | cut -d/ -f1)
  ;;
  (*)
    get_plat_data=$(cat /etc/os-release | grep PRETTY_NAME | awk -F"=" '{print $2}' | awk -F'"' '{ print $2 }')
    get_ip_host=$(/sbin/ip -o -4 addr list | awk '{print $4}' | cut -d/ -f1 | tail -1)
  ;;
esac

# cpu load av
LOAD1=$(cat /proc/loadavg | awk '{ print $1 }')
LOAD5=$(cat /proc/loadavg | awk '{ print $2 }')
LOAD15=$(cat /proc/loadavg | awk '{ print $3 }')
SHOW_LOAD_AVG=`echo -e "$LOAD1" / " $LOAD5 $LOAD15"`

# set COLOR_CLOSE
case $HOSTNAME in
  (odin)  COLOR_CLOSE="";;
  (*)     COLOR_CLOSE="$(tput sgr0)";;
esac

# set title of terminal
trap 'echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD}\007"' DEBUG

# read task file
if [ -f ~/dotfiles/motd/tasks-${HOSTNAME} ]; then
  TASKS="$(cat ~/dotfiles/motd/tasks-${HOSTNAME})"
else
  TASKS="$(cat ~/dotfiles/motd/tasks)"
fi

# use toilet for title of motd
# show all available fonts: https://gist.github.com/itzg/b889534a029855c018813458ff24f23c
case ${HOSTNAME} in
  (odin)
    clear
    echo -e "$COLOR_YELLOW"
cat << EOF
     ▌▗    
▞▀▖▞▀▌▄ ▛▀▖
▌ ▌▌ ▌▐ ▌ ▌
▝▀ ▝▀▘▀▘▘ ▘
EOF
    echo
    ;;
  (*)
    if [ -x "$(command -v toilet)" ]; then
      echo -e "$COLOR_YELLOW"
      toilet -f smblock -w 150 $HOSTNAME | sed 's/^/ /'
      echo -e "$COLOR_CLOSE"
    fi
  ;;
esac

# BUILD THE MOTD OUTPUT
echo -e " $COLOR_BLUE"ip"$COLOR_CLOSE        `echo -e "$COLOR_GREEN$get_ip_host$COLOR_CLOSE"`
 $COLOR_BLUE"tasks"$COLOR_CLOSE     `echo -e "$COLOR_GREEN$TASKS$COLOR_CLOSE"`
 $COLOR_BLUE"load"$COLOR_CLOSE      `echo -e "$COLOR_GREEN$LOAD1$COLOR_CLOSE" / "$COLOR_GREEN$LOAD5$COLOR_CLOSE" / "$COLOR_GREEN$LOAD15$COLOR_CLOSE"`
 $COLOR_BLUE"uptime"$COLOR_CLOSE    `echo -e "$COLOR_GREEN$UPTIME_TEXT$COLOR_CLOSE"`
 $COLOR_BLUE"os"$COLOR_CLOSE        `echo -e "$COLOR_GREEN$get_plat_data$COLOR_CLOSE"`
 $COLOR_BLUE"/"$COLOR_CLOSE         `echo -e "$COLOR_GREEN$USAGE_ROOT_GB$COLOR_CLOSE"` "of" `echo -e "$COLOR_GREEN$USAGE_ROOT_TOTAL$COLOR_CLOSE"` ($USAGE_ROOT%)
 $COLOR_BLUE"/home"$COLOR_CLOSE     `echo -e "$COLOR_GREEN$HOME_USAGE$COLOR_CLOSE"`"

# motd for proxmox
if [ -x /usr/bin/pveversion ]; then
  source ~/dotfiles/motd/motd-proxmox.sh
fi

# motd by hostname
if [ -f ~/dotfiles/motd/motd-$HOSTNAME.sh ]; then
  source ~/dotfiles/motd/motd-$HOSTNAME.sh
else
  echo
fi

# show updates
if [ $MOTD_SHOW_APT_UPDATES=="y" ]; then
  if [ -f /usr/local/share/dotfiles/apt-updates-count ] && [ -f /usr/local/share/dotfiles/apt-updates-packages ]; then
    echo -e "$COLOR_LIGHT_BLUE" APT"$COLOR_CLOSE"
    updates_count=$(</usr/local/share/dotfiles/apt-updates-count)
    updates_packages=$(</usr/local/share/dotfiles/apt-updates-packages)
    echo
    echo -e " "$COLOR_YELLOW$updates_count$COLOR_GREEN" updates to install "$COLOR_YELLOW$updates_packages$COLOR_CLOSE
  fi
fi

# EOF