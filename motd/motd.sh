#!/bin/bash
# https://github.com/fedya/omv_motd.git
# modified by thwalk

# color fallbacks (if config/dotfiles.config was not sourced)
: "${COLOR_BLUE:=}"
: "${COLOR_LIGHT_BLUE:=}"
: "${COLOR_GREEN:=}"
: "${COLOR_YELLOW:=}"
: "${COLOR_RESET:=$(tput sgr0 2>/dev/null || true)}"

# Detect OS if not already set (DOTFILES_OS is exported by components/platform).
if [[ -z ${DOTFILES_OS:-} ]]; then
	case "$(uname -s 2>/dev/null)" in
	Linux) DOTFILES_OS="linux" ;;
	Darwin) DOTFILES_OS="darwin" ;;
	*) DOTFILES_OS="unknown" ;;
	esac
fi

# uptime
if [[ ${DOTFILES_OS} == "darwin" ]]; then
	UPTIME_TEXT="$(/usr/bin/uptime 2>/dev/null | sed -e 's/.*up *//' -e 's/, *[0-9]* users.*//')"
else
	if UPTIME_TEXT="$(/usr/bin/uptime -p 2>/dev/null)"; then
		:
	else
		UPTIME_TEXT="$(/usr/bin/uptime 2>/dev/null | sed -e 's/.*up *//' -e 's/, *[0-9]* users.*//')"
	fi
fi
UPTIME_TEXT="${UPTIME_TEXT:-unknown}"

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

# home-size (cache, fallback to df /home or /Users)
HOME_MOUNT="/home"
if [[ ${DOTFILES_OS} == "darwin" && -d /Users ]]; then
	HOME_MOUNT="/Users"
elif [[ ! -d /home && -d /Users ]]; then
	HOME_MOUNT="/Users"
fi
if [[ -f /usr/local/share/dotfiles/dir-sizes ]]; then
	USAGE_HOME=$(</usr/local/share/dotfiles/dir-sizes)
elif HOME_DF=$(df -h "${HOME_MOUNT}" 2>/dev/null | awk 'NR==2 {print $3, $2, $5}'); then
	# shellcheck disable=SC2086
	read -r USAGE_HOME_USED USAGE_HOME_TOTAL USAGE_HOME_PCT <<<"${HOME_DF}"
	USAGE_HOME="${USAGE_HOME_USED} of ${USAGE_HOME_TOTAL} (${USAGE_HOME_PCT})"
else
	USAGE_HOME="unknown"
fi

# get hostname
HOSTNAME=$(hostname)

# get primary host IP
dotfiles_motd_get_ip() {
	if [[ ${DOTFILES_OS} == "darwin" ]]; then
		if command -v ipconfig >/dev/null 2>&1; then
			ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || true
			return 0
		fi
		if command -v ifconfig >/dev/null 2>&1; then
			ifconfig 2>/dev/null | awk '/inet / {print $2}' | grep -v '^127\\.' | grep -v '^169\\.254\\.' | head -n 1 || true
			return 0
		fi
	fi

	if command -v /sbin/ip >/dev/null 2>&1; then
		/sbin/ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i=1;i<=NF;i++) if ($i=="src") {print $(i+1); exit}}'
	elif command -v ip >/dev/null 2>&1; then
		ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i=1;i<=NF;i++) if ($i=="src") {print $(i+1); exit}}'
	else
		hostname -I 2>/dev/null | awk '{for (i=1;i<=NF;i++) if ($i !~ /^127\\./) {print $i; exit}}'
	fi
}

# get os version & ip & cputemp
case ${HOSTNAME} in
odin)
	GET_PLATFORM_DATA="Synology DSM "$(cat /etc.defaults/VERSION | grep productversion | awk -F'=' '{print $2}' | sed 's/"//' | sed 's/"//')
	#GET_CPU_TEMP=$(($(cat /sys/class/hwmon/hwmon0/temp1_input) / 1000))"°C"
	GET_HOST_IP="$(dotfiles_motd_get_ip || true)"
	;;
*)
	if [[ -r /etc/os-release ]]; then
		GET_PLATFORM_DATA=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | awk -F"=" '{print $2}' | awk -F'"' '{ print $2 }')
	elif command -v sw_vers >/dev/null 2>&1; then
		GET_PLATFORM_DATA="$(sw_vers -productName 2>/dev/null) $(sw_vers -productVersion 2>/dev/null)"
	else
		GET_PLATFORM_DATA="$(uname -s)"
	fi
	GET_HOST_IP="$(dotfiles_motd_get_ip || true)"
	;;
esac

# cpu load av
if [[ -r /proc/loadavg ]]; then
	LOAD1=$(awk '{ print $1 }' /proc/loadavg || true)
	LOAD5=$(awk '{ print $2 }' /proc/loadavg || true)
	LOAD15=$(awk '{ print $3 }' /proc/loadavg || true)
elif command -v sysctl >/dev/null 2>&1; then
	read -r LOAD1 LOAD5 LOAD15 <<<"$(sysctl -n vm.loadavg 2>/dev/null | tr -d '{}' | awk '{print $1, $2, $3}')"
fi
LOAD1="${LOAD1:-n/a}"
LOAD5="${LOAD5:-n/a}"
LOAD15="${LOAD15:-n/a}"

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
	echo
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
			echo
			printf '%b' "${COLOR_YELLOW}"
			toilet -f smblock -w 150 "${HOSTNAME}" 2>/dev/null | sed 's/^/  /'
			printf '%b' "${COLOR_CLOSE}"
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
	printf "  %b%-11s%b %b%s%b\n" \
		"${COLOR_BLUE}" "${label}" "${COLOR_RESET}" \
		"${COLOR_GREEN}" "$*" "${COLOR_RESET}"
}
printf "\n"
if [[ -n ${GET_HOST_IP} ]]; then
	print_kv ip "${GET_HOST_IP}"
fi
if [[ -n ${TASKS} ]]; then
	print_kv tasks "${TASKS}"
fi
print_kv load "${LOAD1} / ${LOAD5} / ${LOAD15}"
print_kv uptime "${UPTIME_TEXT}"
print_kv os "${GET_PLATFORM_DATA}"
print_kv / "${USAGE_ROOT_GB} of ${USAGE_ROOT_TOTAL} (${USAGE_ROOT}%%)"
if [[ -n ${USAGE_HOME} && ${USAGE_HOME} != "unknown" ]]; then
	print_kv /home "${USAGE_HOME}"
fi

# "updates" line needs two different colours → do it explicitly
if [[ ${SHOW_UPDATES_LINE} == true ]]; then
	printf "  %b%-11s%b %b%s%b%b%s%b\n" \
		"${COLOR_BLUE}" "updates" "${COLOR_RESET}" \
		"${COLOR_YELLOW}" "${UPDATES_COUNT}" "${COLOR_RESET}" \
		"${COLOR_GREEN}" " updates to install" "${COLOR_RESET}"
fi

# warn if tasks.json present but jq missing
if [[ -n ${JQ_MISSING_MSG} ]]; then
	print_kv tasks "${JQ_MISSING_MSG}"
fi

# Load and run MOTD widgets (if enabled)
if [[ ${DOTFILES_ENABLE_MOTD_WIDGETS:-true} == true ]]; then
	if [[ -f ~/dotfiles/motd/widgets.sh ]]; then
		# shellcheck source=/dev/null
		source ~/dotfiles/motd/widgets.sh
		motd_run_widgets
	fi
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
