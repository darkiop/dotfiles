#!/bin/bash
#
# Server Status Script
# Version 0.1.2 m
# Updated: Feb 29th 2016
# https://github.com/fedya/omv_motd.git
# License: GPLv3

# modified by thwalk

upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
UP=`printf "%d days, %02dh:%02dm:%02ds" "$days" "$hours" "$mins" "$secs"`

root_usage=$(df -h / | awk '/\// {print $(NF-1)}' | sed 's/%//g')
root_usage_gb=$(df -h / | awk '/\// {print $(NF-3)}')
root_total=$(df -h / | awk '/\// {print $(NF-4)}')

if [ -d /home]; then
  home_usage_gb=$(df -h /home | awk '/\// {print $(NF-3)}')
  home_total=$(df -h /home | awk '/\// {print $(NF-4)}')
fi

# 26%/4135 MB of 16041MB
memory_usage=$(free | awk '/Speicher/ {printf("%.0f",(($2-($4+$6+$7))/$2) * 100)}')
memory_total=$(free -m |  awk '/Speicher/ {print $(2)}')
memory_usage_gb=$(free -t -m | grep "buffers/cache" | awk '{print $3" MB";}')

users=$(users)

get_host_name=$(hostname)

case $get_host_name in
  (odin) get_plat_data="Synology DSM "$(cat /etc.defaults/VERSION | grep productversion | awk -F'=' '{print $2}' | sed 's/"//' | sed 's/"//')
         get_ip_host=$(/sbin/ip -o -4 addr list ovs_eth0 | awk '{print $4}' | cut -d/ -f1);;
  (*)    get_plat_data=$(cat /etc/os-release | grep PRETTY_NAME | awk -F"=" '{print $2}' | awk -F'"' '{ print $2 }')
         get_ip_host=$(/sbin/ip -o -4 addr list | awk '{print $4}' | cut -d/ -f1 | tail -1);;
esac

get_os_load_1=$(cat /proc/loadavg | awk '{ print $1 }')
get_os_load_5=$(cat /proc/loadavg | awk '{ print $2 }')
get_os_load_15=$(cat /proc/loadavg | awk '{ print $3 }')

get_os_loadavg=`echo -e "$get_os_load_1" / " $get_os_load_5 $get_os_load_15"`

get_proc_ps=$(ps -Afl | wc -l)
get_swap=$(free -m | tail -n 1 | awk {'print $3'})

blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"

case $get_host_name in
  (odin)  close_color=""
  (*)     close_color="$(tput sgr0)"
esac

if [ -f ~/dotfiles/motd/tasks-$get_host_name ]; then
  tasks="$(cat ~/dotfiles/motd/tasks-$(hostname))"
else
  tasks="$(cat ~/dotfiles/motd/tasks)"
fi

echo -e "
$light_blue_color"System Status:"$close_color
$yellow_color"--------------------------------------"
$blue_color"hostname"$close_color          `echo -e "$green_color$get_host_name$close_color"`
$blue_color"ip"$close_color                `echo -e "$green_color$get_ip_host$close_color"`
$blue_color"tasks"$close_color             `echo -e "$green_color$tasks$close_color"`
$blue_color"load"$close_color              `echo -e "$green_color$get_os_load_1$close_color" / "$green_color$get_os_load_5$close_color" / "$green_color$get_os_load_15$close_color" `
$blue_color"uptime"$close_color            `echo -e "$green_color$UP$close_color"`
$blue_color"logged in users"$close_color   `echo -e "$green_color$users$close_color"`
$blue_color"os"$close_color                `echo -e "$green_color$get_plat_data$close_color"`
$blue_color"usage of /"$close_color        `echo -e "$green_color$root_usage% $close_color"`/ ` echo -e "$green_color$root_usage_gb$close_color"` "of" `echo -e "$green_color$root_total$close_color"`
"

