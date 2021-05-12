#!/bin/bash
# https://github.com/fedya/omv_motd.git
# modified by thwalk

HOSTNAME=$(hostname)

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
get_os_load_1=$(cat /proc/loadavg | awk '{ print $1 }')
get_os_load_5=$(cat /proc/loadavg | awk '{ print $2 }')
get_os_load_15=$(cat /proc/loadavg | awk '{ print $3 }')
get_os_loadavg=`echo -e "$get_os_load_1" / " $get_os_load_5 $get_os_load_15"`
get_proc_ps=$(ps -Afl | wc -l)
get_swap=$(free -m | tail -n 1 | awk {'print $3'})

# set close_color
case $HOSTNAME in
  (odin)  close_color="";;
  (*)     close_color="$(tput sgr0)";;
esac

# set title of terminal
trap 'echo -ne "\033]0;${USER}@${HOSTNAME}\007"' DEBUG

# read task file
if [ -f ~/dotfiles/motd/tasks-$HOSTNAME ]; then
  tasks="$(cat ~/dotfiles/motd/tasks-$(HOSTNAME))"
else
  tasks="$(cat ~/dotfiles/motd/tasks)"
fi

# use toilet for title of motd
# show all available fonts: https://gist.github.com/itzg/b889534a029855c018813458ff24f23c
case $HOSTNAME in
  (odin)
    clear
    echo -e "$yellow_color"
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
      echo -e "$yellow_color"
      toilet -f smblock -w 150 $HOSTNAME
      echo -e "$close_color"
    fi
  ;;
esac

# echo infos
echo -e "$blue_color"hostname"$close_color          `echo -e "$green_color$HOSTNAME$close_color"`
$blue_color"ip"$close_color                `echo -e "$green_color$get_ip_host$close_color"`
$blue_color"tasks"$close_color             `echo -e "$green_color$tasks$close_color"`
$blue_color"load"$close_color              `echo -e "$green_color$get_os_load_1$close_color" / "$green_color$get_os_load_5$close_color" / "$green_color$get_os_load_15$close_color"`
$blue_color"uptime"$close_color            `echo -e "$green_color$UP$close_color"`
$blue_color"os"$close_color                `echo -e "$green_color$get_plat_data$close_color"`
$blue_color"usage of /"$close_color        `echo -e "$green_color$root_usage_gb$close_color"` "of" `echo -e "$green_color$root_total$close_color"` ($root_usage%)
$blue_color"usage of /home"$close_color    `echo -e "$green_color$home_usage_gb$close_color"` "of" `echo -e "$green_color$home_total$close_color"` ($home_usage%)"

# special motd for proxmox
if [ -x /usr/bin/pveversion ]; then
  source ~/dotfiles/motd/motd-proxmox.sh
fi

# special motd by hostname
if [ -f ~/dotfiles/motd/motd-$HOSTNAME.sh ]; then
  source ~/dotfiles/motd/motd-$HOSTNAME.sh
else
  echo
fi

# show updates
if [ $(which apt) ]; then
  echo -e "$light_blue_color"Checking for updates ..."$close_color"
  updates="$(apt-get -s dist-upgrade | awk '/^Inst/ { print $2 }')"
  updatesText="$green_color$close_color $yellow_color$updates$close_color"
  if [ "$(which apt-get)" ]; then
    echo
    echo -e $yellow_color"`apt-get -s -o Debug::NoLocking=true upgrade | grep ^Inst | wc -l` "$green_color"updates to install"$close_color$updatesText
    echo
  fi
fi

# EOF