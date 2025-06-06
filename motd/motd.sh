#!/bin/bash
# https://github.com/fedya/omv_motd.git
# modified by thwalk

# uptime
UPTIME_TEXT="$(/usr/bin/uptime -p)"

# size of /
USAGE_ROOT=$(df -h / | awk '/\// {print $(NF-1)}' | sed 's/%//g' || true)
USAGE_ROOT_GB=$(df -h / | awk '/\// {print $(NF-3)}' || true)
USAGE_ROOT_TOTAL=$(df -h / | awk '/\// {print $(NF-4)}' || true)

# home-size
if [[ -f /usr/local/share/dotfiles/dir-sizes ]]; then
	USAGE_HOME=$(</usr/local/share/dotfiles/dir-sizes)
else
	USAGE_HOME="Source file not found"
fi

# get hostname
HOSTNAME=$(hostname)

# get os version & ip & cputemp
case ${HOSTNAME} in
odin)
	GET_PLATFORM_DATA="Synology DSM "$(cat /etc.defaults/VERSION | grep productversion | awk -F'=' '{print $2}' | sed 's/"//' | sed 's/"//')
	#GET_CPU_TEMP=$(($(cat /sys/class/hwmon/hwmon0/temp1_input) / 1000))"°C"
	GET_HOST_IP=$(/sbin/ip -o -4 addr list ovs_eth0 | awk '{print $4}' | cut -d/ -f1)
	;;
*)
	GET_PLATFORM_DATA=$(cat /etc/os-release | grep PRETTY_NAME | awk -F"=" '{print $2}' | awk -F'"' '{ print $2 }')
	GET_HOST_IP=$(/sbin/ip -o -4 addr list | awk '{print $4}' | cut -d/ -f1 | tail -1)
	;;
esac

# cpu load av
LOAD1=$(awk '{ print $1 }' /proc/loadavg || true)
LOAD5=$(awk '{ print $2 }' /proc/loadavg || true)
LOAD15=$(cat /proc/loadavg | awk '{ print $3 }' || true)

# set COLOR_CLOSE
case ${HOSTNAME} in
odin) COLOR_CLOSE="" ;;
*) COLOR_CLOSE="$(tput sgr0)" ;;
esac

# set title of terminal
trap 'echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD}\007"' DEBUG

# read task file
if [[ -f ~/dotfiles/motd/tasks-${HOSTNAME} ]]; then
	TASKS="$(cat ~/dotfiles/motd/tasks-"${HOSTNAME}")"
else
	TASKS="$(cat ~/dotfiles/motd/tasks)"
fi

# use toilet for title of motd
# show all available fonts: https://gist.github.com/itzg/b889534a029855c018813458ff24f23c
case ${HOSTNAME} in
odin)
	clear
	echo -e "${COLOR_YELLOW}"
	cat <<EOF
     ▌▗    
▞▀▖▞▀▌▄ ▛▀▖
▌ ▌▌ ▌▐ ▌ ▌
▝▀ ▝▀▘▀▘▘ ▘
EOF
	echo
	;;
*)
	if command -v toilet >/dev/null 2>&1; then
		if TOILET_OUTPUT=$(toilet -f smblock -w 150 "${HOSTNAME}"); then
			echo -e "${COLOR_YELLOW}"
			echo -e " ${TOILET_OUTPUT//$'\n'/$'\n '}"
			echo -e "${COLOR_CLOSE}"
		fi
	fi
	;;
esac

# show updates
if [[ ${MOTD_SHOW_APT_UPDATES} == "y" ]]; then
	if [[ -f /usr/local/share/dotfiles/apt-updates-count ]] && [[ -f /usr/local/share/dotfiles/apt-updates-packages ]]; then
		UPDATES_COUNT=$(</usr/local/share/dotfiles/apt-updates-count)
		UPDATES_PACKAGES=$(</usr/local/share/dotfiles/apt-updates-packages)
	fi
fi

# BUILD THE MOTD OUTPUT
print_kv() {
	local label=$1
	shift # first arg  = label
	printf "%b%-11s%b %b%s%b\n" \
		"${COLOR_BLUE}" "${label}" "${COLOR_RESET}" \
		"${COLOR_GREEN}" "$*" "${COLOR_RESET}"
}
printf "\n"
print_kv ip "${GET_HOST_IP}"
print_kv tasks "${TASKS}"
print_kv load "${LOAD1} / ${LOAD5} / ${LOAD15}"
print_kv uptime "${UPTIME_TEXT}"
print_kv os "${GET_PLATFORM_DATA}"
print_kv / "${USAGE_ROOT_GB} of ${USAGE_ROOT_TOTAL} (${USAGE_ROOT}%%)"
print_kv /home "${USAGE_HOME}"

# “updates” line needs two different colours → do it explicitly
printf "%b%-11s%b %b%s%b%b%s%b%b%s%b\n" \
	"${COLOR_BLUE}" "updates" "${COLOR_RESET}" \
	"${COLOR_GREEN}" "" "${COLOR_RESET}" \
	"${COLOR_YELLOW}" "${UPDATES_COUNT}" "${COLOR_RESET}" \
	"${COLOR_GREEN}" " updates to install " "${COLOR_RESET}" \
	"${COLOR_YELLOW}" "${UPDATES_PACKAGES}" \
	"${COLOR_RESET}"

printf "\n"

# motd for proxmox
if [[ ${EUID} -ne 0 ]]; then
	if [[ -x /usr/bin/pveversion ]]; then
		# shellcheck source=/dev/null
		source ~/dotfiles/motd/motd-proxmox.sh
	fi
fi

# motd by hostname
if [[ -f ~/dotfiles/motd/motd-${HOSTNAME}.sh ]]; then
	# shellcheck source=/dev/null
	source ~/dotfiles/motd/motd-"${HOSTNAME}".sh
else
	echo
fi
