#!/bin/bash
# https://github.com/fedya/omv_motd.git
# modified by thwalk
#
# Supports two styles via DOTFILES_MOTD_STYLE:
#   - "tree" (default): compact tree-style layout like `dot help --plain`
#   - "default": toilet banner + simple key-value lines

# ============================================================================
# Color Setup
# ============================================================================
: "${COLOR_BLUE:=}"
: "${COLOR_LIGHT_BLUE:=}"
: "${COLOR_GREEN:=}"
: "${COLOR_YELLOW:=}"
: "${COLOR_RED:=}"
: "${COLOR_RESET:=$(tput sgr0 2>/dev/null || true)}"

# Detect OS if not already set (DOTFILES_OS is exported by components/platform).
if [[ -z ${DOTFILES_OS:-} ]]; then
	case "$(uname -s 2>/dev/null)" in
	Linux) DOTFILES_OS="linux" ;;
	Darwin) DOTFILES_OS="darwin" ;;
	*) DOTFILES_OS="unknown" ;;
	esac
fi

# ============================================================================
# Data Collection (shared by all styles)
# ============================================================================

# Uptime
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

# Determine home mount point
HOME_MOUNT="/home"
if [[ ${DOTFILES_OS} == "darwin" && -d /Users ]]; then
	HOME_MOUNT="/Users"
elif [[ ! -d /home && -d /Users ]]; then
	HOME_MOUNT="/Users"
fi

# Disk usage
USAGE_ROOT_TOTAL=""
USAGE_ROOT_GB=""
USAGE_ROOT=""
USAGE_HOME="unknown"

if [[ -f /usr/local/share/dotfiles/dir-sizes ]]; then
	USAGE_HOME=$(</usr/local/share/dotfiles/dir-sizes)
	if ROOT_DF=$(df -h / 2>/dev/null | awk 'NR==2 {print $2, $3, $5}'); then
		# shellcheck disable=SC2086
		read -r USAGE_ROOT_TOTAL USAGE_ROOT_GB USAGE_ROOT_PCT <<<"${ROOT_DF}"
		USAGE_ROOT="${USAGE_ROOT_PCT%\%}"
	fi
else
	if DF_OUTPUT=$(df -h / "${HOME_MOUNT}" 2>/dev/null); then
		if ROOT_DF=$(echo "${DF_OUTPUT}" | awk 'NR==2 {print $2, $3, $5}'); then
			# shellcheck disable=SC2086
			read -r USAGE_ROOT_TOTAL USAGE_ROOT_GB USAGE_ROOT_PCT <<<"${ROOT_DF}"
			USAGE_ROOT="${USAGE_ROOT_PCT%\%}"
		fi
		if HOME_DF=$(echo "${DF_OUTPUT}" | awk 'NR==3 {print $3, $2, $5}'); then
			if [[ -n ${HOME_DF} ]]; then
				# shellcheck disable=SC2086
				read -r USAGE_HOME_USED USAGE_HOME_TOTAL USAGE_HOME_PCT <<<"${HOME_DF}"
				USAGE_HOME="${USAGE_HOME_USED} of ${USAGE_HOME_TOTAL} (${USAGE_HOME_PCT})"
			else
				USAGE_HOME="${USAGE_ROOT_GB}"
			fi
		fi
	fi
fi

# Hostname
HOSTNAME=$(hostname)
HOSTNAME_SHORT="${HOSTNAME%%.*}"

# IP address
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

# OS version & IP
case ${HOSTNAME} in
odin)
	GET_PLATFORM_DATA="Synology DSM "$(command cat /etc.defaults/VERSION | grep productversion | awk -F'=' '{print $2}' | sed 's/"//' | sed 's/"//')
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

# CPU load
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

# Color close
case ${HOSTNAME} in
odin) COLOR_CLOSE="" ;;
*) COLOR_CLOSE="$(tput sgr0)" ;;
esac

# Tasks
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
		TASKS="$(command cat ~/dotfiles/motd/tasks-"${HOSTNAME}")"
	elif [[ -f ~/dotfiles/motd/tasks ]]; then
		TASKS="$(command cat ~/dotfiles/motd/tasks)"
	fi
fi

# Updates
SHOW_UPDATES_LINE=false
UPDATES_COUNT=""
UPDATES_PACKAGES=""
if [[ ${MOTD_SHOW_APT_UPDATES} == "y" ]]; then
	if [[ -f /usr/local/share/dotfiles/apt-updates-count ]] && [[ -f /usr/local/share/dotfiles/apt-updates-packages ]]; then
		UPDATES_COUNT=$(</usr/local/share/dotfiles/apt-updates-count)
		UPDATES_PACKAGES=$(</usr/local/share/dotfiles/apt-updates-packages)
		if [[ -n ${UPDATES_COUNT} ]]; then
			SHOW_UPDATES_LINE=true
		fi
	fi
fi

# ============================================================================
# Helper Functions
# ============================================================================

_motd_sanitize_value() {
	printf '%s' "$1"
}

# ============================================================================
# Default Style (toilet banner + key-value lines)
# ============================================================================

_motd_render_default() {
	# Print key-value line
	print_kv() {
		local label=$1
		shift
		local value="$*"
		local value_color="${COLOR_GREEN}"
		local value_reset="${COLOR_RESET}"

		case "${label}" in
			ip|tailscale|wireguard)
				value=$(_motd_sanitize_value "${value}")
				;;
			network)
				value_color=""
				value_reset=""
				;;
		esac

		printf "  %b%-11s%b %b%s%b\n" \
			"${COLOR_BLUE}" "${label}" "${COLOR_RESET}" \
			"${value_color}" "${value}" "${value_reset}"
	}

	# Banner
	case ${HOSTNAME} in
	odin)
		clear
		echo
		echo -e "${COLOR_YELLOW}"
		command cat <<EOF
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
			banner_cache="${HOME}/.cache/dotfiles/motd/banner-${HOSTNAME_SHORT}"
			if [[ ! -f ${banner_cache} ]]; then
				mkdir -p "${HOME}/.cache/dotfiles/motd" 2>/dev/null || true
				toilet -f smblock -w 150 "${HOSTNAME_SHORT}" 2>/dev/null | sed 's/^/  /' > "${banner_cache}"
			fi
			command cat "${banner_cache}"
			printf '%b' "${COLOR_CLOSE}"
		fi
		;;
	esac

	# Output
	printf "\n"
	[[ -n ${TASKS} ]] && print_kv description "${TASKS}"
	[[ -n ${GET_HOST_IP} ]] && print_kv ip "${GET_HOST_IP}"
	print_kv load "${LOAD1} / ${LOAD5} / ${LOAD15}"
	print_kv uptime "${UPTIME_TEXT}"
	print_kv os "${GET_PLATFORM_DATA}"
	print_kv / "${USAGE_ROOT_GB} of ${USAGE_ROOT_TOTAL} (${USAGE_ROOT}%%)"
	[[ -n ${USAGE_HOME} && ${USAGE_HOME} != "unknown" ]] && print_kv /home "${USAGE_HOME}"

	if [[ ${SHOW_UPDATES_LINE} == true ]]; then
		printf "  %b%-11s%b %b%s%b%b%s%b\n" \
			"${COLOR_BLUE}" "updates" "${COLOR_RESET}" \
			"${COLOR_YELLOW}" "${UPDATES_COUNT}" "${COLOR_RESET}" \
			"${COLOR_GREEN}" " updates to install" "${COLOR_RESET}"
	fi

	[[ -n ${JQ_MISSING_MSG} ]] && print_kv description "${JQ_MISSING_MSG}"

	# Widgets
	if [[ ${DOTFILES_ENABLE_MOTD_WIDGETS:-true} == true ]]; then
		if [[ -f ~/dotfiles/motd/widgets.sh ]]; then
			# shellcheck source=/dev/null
			source ~/dotfiles/motd/widgets.sh
			motd_run_widgets
		fi
	fi

	printf "\n"
}

# ============================================================================
# Tree Style (tree layout like `dot help --plain`)
# ============================================================================

_motd_render_tree() {
	# Box drawing characters
	local tree_mid="├─" tree_end="╰─"

	# Colors
	local c_head="${COLOR_LIGHT_BLUE}"
	local c_label="${COLOR_BLUE}"
	local c_value="${COLOR_GREEN}"
	local c_reset="${COLOR_RESET}"

	# Section header
	_motd_tree_section() {
		printf '  %b%s%b\n' "${c_head}" "$1" "${c_reset}"
	}

	# Tree item (mid or end)
	_motd_tree_item() {
		local is_last="$1"
		local label="$2"
		shift 2
		local value="$*"
		local tree_char="${tree_mid}"
		[[ ${is_last} == "1" ]] && tree_char="${tree_end}"

		# Handle special labels that provide their own colors
		case "${label}" in
			network)
				printf '  %b%s%b %-14s %s\n' \
					"${c_label}" "${tree_char}" "${c_reset}" \
					"${label}" "${value}"
				;;
			*)
				printf '  %b%s%b %-14s %b%s%b\n' \
					"${c_label}" "${tree_char}" "${c_reset}" \
					"${label}" \
					"${c_value}" "${value}" "${c_reset}"
				;;
		esac
	}

	# Collect widget outputs for minimal style
	declare -a _motd_widget_items=()
	_motd_tree_collect_widgets() {
		if [[ ${DOTFILES_ENABLE_MOTD_WIDGETS:-true} != true ]]; then
			return
		fi
		if [[ ! -f ~/dotfiles/motd/widgets.sh ]]; then
			return
		fi

		# Source widgets but override print_kv to collect instead of print
		print_kv() {
			_motd_widget_items+=("$1|$2")
		}

		# shellcheck source=/dev/null
		source ~/dotfiles/motd/widgets.sh
		motd_run_widgets

		unset -f print_kv
	}

	# Render

	# Banner (same as default style)
	case ${HOSTNAME} in
	odin)
		clear
		echo
		echo -e "${COLOR_YELLOW}"
		command cat <<EOF
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
			banner_cache="${HOME}/.cache/dotfiles/motd/banner-${HOSTNAME_SHORT}"
			if [[ ! -f ${banner_cache} ]]; then
				mkdir -p "${HOME}/.cache/dotfiles/motd" 2>/dev/null || true
				toilet -f smblock -w 150 "${HOSTNAME_SHORT}" 2>/dev/null | sed 's/^/  /' > "${banner_cache}"
			fi
			command cat "${banner_cache}"
			printf '%b\n' "${COLOR_CLOSE}"
		fi
		;;
	esac

	# Description (if any)
	if [[ -n ${TASKS} ]]; then
		_motd_tree_section "Description"
		_motd_tree_item 1 "current" "${TASKS}"
	fi

	# System section
	_motd_tree_section "System"
	[[ -n ${GET_HOST_IP} ]] && _motd_tree_item 0 "ip" "${GET_HOST_IP}"
	_motd_tree_item 0 "os" "${GET_PLATFORM_DATA}"
	_motd_tree_item 0 "load" "${LOAD1} / ${LOAD5} / ${LOAD15}"
	_motd_tree_item 1 "uptime" "${UPTIME_TEXT}"
	_motd_tree_section "Storage"
	if [[ -n ${USAGE_HOME} && ${USAGE_HOME} != "unknown" ]]; then
		_motd_tree_item 0 "/" "${USAGE_ROOT_GB} of ${USAGE_ROOT_TOTAL} (${USAGE_ROOT}%)"
		_motd_tree_item 1 "/home" "${USAGE_HOME}"
	else
		_motd_tree_item 1 "/" "${USAGE_ROOT_GB} of ${USAGE_ROOT_TOTAL} (${USAGE_ROOT}%)"
	fi

	# Updates (if any)
	if [[ ${SHOW_UPDATES_LINE} == true ]]; then
		_motd_tree_section "Updates"
		_motd_tree_item 1 "apt" "${UPDATES_COUNT} packages available"
	fi

	# Widgets
	_motd_tree_collect_widgets
	if [[ ${#_motd_widget_items[@]} -gt 0 ]]; then
		_motd_tree_section "Services"
		local total=${#_motd_widget_items[@]}
		local idx=0
		for item in "${_motd_widget_items[@]}"; do
			idx=$((idx + 1))
			local label="${item%%|*}"
			local value="${item#*|}"
			if [[ ${idx} -eq ${total} ]]; then
				_motd_tree_item 1 "${label}" "${value}"
			else
				_motd_tree_item 0 "${label}" "${value}"
			fi
		done
	fi

	echo
}

# ============================================================================
# Style Selection
# ============================================================================

case "${DOTFILES_MOTD_STYLE:-tree}" in
	default|classic)
		_motd_render_default
		;;
	*)
		_motd_render_tree
		;;
esac
