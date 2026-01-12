#!/bin/bash
# https://github.com/fedya/omv_motd.git
# modified by thwalk

# color fallbacks (if config/dotfiles.config was not sourced)
: "${COLOR_BLUE:=}"
: "${COLOR_LIGHT_BLUE:=}"
: "${COLOR_GREEN:=}"
: "${COLOR_YELLOW:=}"
: "${COLOR_RESET:=$(tput sgr0 2>/dev/null || true)}"

# uptime
UPTIME_TEXT="$(/usr/bin/uptime -p)"

# size of / (single df call)
if ROOT_DF=$(df -h / 2>/dev/null | awk 'NR==2 {print $2, $3, $5}'); then
	# shellcheck disable=SC2086
	read -r USAGE_ROOT_TOTAL USAGE_ROOT_GB USAGE_ROOT_PCT <<<"${ROOT_DF}"
	USAGE_ROOT="${USAGE_ROOT_PCT%\%}"
else
	USAGE_ROOT_TOTAL=""
	USAGE_ROOT_GB=""
	USAGE_ROOT=""
fi

# home-size (cache, fallback to df /home)
if [[ -f /usr/local/share/dotfiles/dir-sizes ]]; then
	USAGE_HOME=$(</usr/local/share/dotfiles/dir-sizes)
elif HOME_DF=$(df -h /home 2>/dev/null | awk 'NR==2 {print $3, $2, $5}'); then
	# shellcheck disable=SC2086
	read -r USAGE_HOME_USED USAGE_HOME_TOTAL USAGE_HOME_PCT <<<"${HOME_DF}"
	USAGE_HOME="${USAGE_HOME_USED} of ${USAGE_HOME_TOTAL} (${USAGE_HOME_PCT})"
else
	USAGE_HOME="unknown"
fi

# get hostname
HOSTNAME=$(hostname)

# get os version & ip & cputemp
case ${HOSTNAME} in
odin)
	GET_PLATFORM_DATA="Synology DSM "$(cat /etc.defaults/VERSION | grep productversion | awk -F'=' '{print $2}' | sed 's/"//' | sed 's/"//')
	#GET_CPU_TEMP=$(($(cat /sys/class/hwmon/hwmon0/temp1_input) / 1000))"°C"
	if GET_HOST_IP=$(/sbin/ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i=1;i<=NF;i++) if ($i=="src") {print $(i+1); exit}}'); then
		:
	elif GET_HOST_IP=$(hostname -I 2>/dev/null | awk '{for (i=1;i<=NF;i++) if ($i !~ /^127\\./) {print $i; exit}}'); then
		:
	else
		GET_HOST_IP=""
	fi
	;;
*)
	GET_PLATFORM_DATA=$(cat /etc/os-release | grep PRETTY_NAME | awk -F"=" '{print $2}' | awk -F'"' '{ print $2 }')
	if GET_HOST_IP=$(/sbin/ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i=1;i<=NF;i++) if ($i=="src") {print $(i+1); exit}}'); then
		:
	elif GET_HOST_IP=$(hostname -I 2>/dev/null | awk '{for (i=1;i<=NF;i++) if ($i !~ /^127\\./) {print $i; exit}}'); then
		:
	else
		GET_HOST_IP=""
	fi
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

# read tasks (JSON via jq; fallback to legacy files only if present)
TASKS=""
JQ_MISSING_MSG=""
if [[ -f ~/dotfiles/motd/tasks.json ]]; then
	if command -v jq >/dev/null 2>&1; then
		TASKS="$(jq -r --arg host "${HOSTNAME}" '(.[$host] // .default // "")' ~/dotfiles/motd/tasks.json 2>/dev/null)"
	else
		JQ_MISSING_MSG="(jq missing for tasks.json)"
	fi
fi

if [[ -z ${TASKS} ]]; then
	if [[ -f ~/dotfiles/motd/tasks-${HOSTNAME} ]]; then
		TASKS="$(cat ~/dotfiles/motd/tasks-"${HOSTNAME}")"
	elif [[ -f ~/dotfiles/motd/tasks ]]; then
		TASKS="$(cat ~/dotfiles/motd/tasks)"
	fi
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

# show updates (only when enabled and cache files exist)
SHOW_UPDATES_LINE=false
if [[ ${MOTD_SHOW_APT_UPDATES} == "y" ]]; then
	if [[ -f /usr/local/share/dotfiles/apt-updates-count ]] && [[ -f /usr/local/share/dotfiles/apt-updates-packages ]]; then
		UPDATES_COUNT=$(</usr/local/share/dotfiles/apt-updates-count)
		UPDATES_PACKAGES=$(</usr/local/share/dotfiles/apt-updates-packages)
		if [[ -n ${UPDATES_COUNT} ]]; then
			SHOW_UPDATES_LINE=true
		fi
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
if [[ ${SHOW_UPDATES_LINE} == true ]]; then
	printf "%b%-11s%b %b%s%b%b%s%b\n" \
		"${COLOR_BLUE}" "updates" "${COLOR_RESET}" \
		"${COLOR_YELLOW}" "${UPDATES_COUNT}" "${COLOR_RESET}" \
		"${COLOR_GREEN}" " updates to install" "${COLOR_RESET}"
fi

# warn if tasks.json present but jq missing
if [[ -n ${JQ_MISSING_MSG} ]]; then
	print_kv tasks "${JQ_MISSING_MSG}"
fi

printf "\n"

# motd for proxmox (global, not per-host scripts)
if [[ ${EUID} -ne 0 ]]; then
	if [[ -x /usr/bin/pveversion ]]; then
		# shellcheck source=/dev/null
		source ~/dotfiles/motd/motd-proxmox.sh
	fi
fi

echo
