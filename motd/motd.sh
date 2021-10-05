#!/bin/bash
# https://github.com/fedya/omv_motd.git
# modified by thwalk

# uptime
upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
UP=`printf "%d days, %02dh:%02dm:%02ds" "$days" "$hours" "$mins" "$secs"`

# size of /
root_usage=$(df -h / | awk '/\// {print $(NF-1)}' | sed 's/%//g')
root_usage_gb=$(df -h / | awk '/\// {print $(NF-3)}')
root_total=$(df -h / | awk '/\// {print $(NF-4)}')

# size of /home
if [ -d /home ]; then
  home_usage=$(df -h /home | awk '/\// {print $(NF-1)}' | sed 's/%//g')
  home_usage_gb=$(df -h /home | awk '/\// {print $(NF-3)}')
  home_total=$(df -h /home | awk '/\// {print $(NF-4)}')
fi

# get hostname
get_host_name=$(hostname)

# get os version & ip & cputemp
case $get_host_name in
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
get_os_load_1=$(cat /proc/loadavg | awk '{ print $1 }')
get_os_load_5=$(cat /proc/loadavg | awk '{ print $2 }')
get_os_load_15=$(cat /proc/loadavg | awk '{ print $3 }')
get_os_loadavg=`echo -e "$get_os_load_1" / " $get_os_load_5 $get_os_load_15"`
get_proc_ps=$(ps -Afl | wc -l)
get_swap=$(free -m | tail -n 1 | awk {'print $3'})

# set COLOR_CLOSE
case $get_host_name in
  (odin)  COLOR_CLOSE="";;
  (*)     COLOR_CLOSE="$(tput sgr0)";;
esac

# set title of terminal
trap 'echo -ne "\033]0;${USER}@${get_host_name}:${PWD}\007"' DEBUG

# read task file
if [ -f ~/dotfiles/motd/tasks-${get_host_name} ]; then
  tasks="$(cat ~/dotfiles/motd/tasks-${get_host_name})"
else
  tasks="$(cat ~/dotfiles/motd/tasks)"
fi

# use toilet for title of motd
# show all available fonts: https://gist.github.com/itzg/b889534a029855c018813458ff24f23c
case ${get_host_name} in
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
      toilet -f smblock -w 150 $get_host_name
      echo -e "$COLOR_CLOSE"
    fi
  ;;
esac

# echo infos
echo -e "$COLOR_BLUE"ip"$COLOR_CLOSE                `echo -e "$COLOR_GREEN$get_ip_host$COLOR_CLOSE"`
$COLOR_BLUE"tasks"$COLOR_CLOSE             `echo -e "$COLOR_GREEN$tasks$COLOR_CLOSE"`
$COLOR_BLUE"load"$COLOR_CLOSE              `echo -e "$COLOR_GREEN$get_os_load_1$COLOR_CLOSE" / "$COLOR_GREEN$get_os_load_5$COLOR_CLOSE" / "$COLOR_GREEN$get_os_load_15$COLOR_CLOSE"`
$COLOR_BLUE"uptime"$COLOR_CLOSE            `echo -e "$COLOR_GREEN$UP$COLOR_CLOSE"`
$COLOR_BLUE"os"$COLOR_CLOSE                `echo -e "$COLOR_GREEN$get_plat_data$COLOR_CLOSE"`
$COLOR_BLUE"usage of /"$COLOR_CLOSE        `echo -e "$COLOR_GREEN$root_usage_gb$COLOR_CLOSE"` "of" `echo -e "$COLOR_GREEN$root_total$COLOR_CLOSE"` ($root_usage%)
$COLOR_BLUE"usage of /home"$COLOR_CLOSE    `echo -e "$COLOR_GREEN$home_usage_gb$COLOR_CLOSE"` "of" `echo -e "$COLOR_GREEN$home_total$COLOR_CLOSE"` ($home_usage%)"

# special motd for proxmox
if [ -x /usr/bin/pveversion ]; then
  source ~/dotfiles/motd/motd-proxmox.sh
fi

# special motd for redis
#if pgrep -x "redis-server" >/dev/null
#then
#  source ~/dotfiles/motd/motd-redis.sh
#fi

# special motd by hostname
if [ -f ~/dotfiles/motd/motd-$get_host_name.sh ]; then
  source ~/dotfiles/motd/motd-$get_host_name.sh
else
  echo
fi

# show updates
if [ $MOTD_SHOW_APT_UPDATES != 'y' ]; then
  if [ $(which apt) ]; then
    echo -e "$COLOR_LIGHT_BLUE"Checking for updates ..."$COLOR_CLOSE"
    updates="$(apt-get -s dist-upgrade | awk '/^Inst/ { print $2 }')"
    updatesText="$COLOR_GREEN$COLOR_CLOSE $COLOR_YELLOW$updates$COLOR_CLOSE"
    if [ "$(which apt-get)" ]; then
      echo
      echo -e $COLOR_YELLOW"`apt-get -s -o Debug::NoLocking=true upgrade | grep ^Inst | wc -l` "$COLOR_GREEN"updates to install"$COLOR_CLOSE$updatesText
    fi
  fi
fi
# EOF