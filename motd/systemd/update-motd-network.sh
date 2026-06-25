#!/bin/bash

set -euo pipefail

# Cache directory and file
CACHE_DIR="${HOME}/.cache/dotfiles/motd"
CACHE_FILE="${CACHE_DIR}/network"
CONFIG_FILE="${HOME}/dotfiles/config/network-hosts.conf"

# Color codes
C_GREEN=$'\x1b[38;5;83m'
C_RED=$'\x1b[38;5;196m'
C_RESET=$'\x1b[m'

# Platform-specific ping timeout flag
PING_TIMEOUT_FLAG="-W"
case "$(uname -s)" in
	Darwin) PING_TIMEOUT_FLAG="-t" ;;
esac

update_network_cache() {
	if [[ ! -f ${CONFIG_FILE} ]]; then
		echo "Config file not found: ${CONFIG_FILE}" >&2
		return 0
	fi

	mkdir -p "${CACHE_DIR}"

	local output=""
	local host status_color status_symbol

	while IFS= read -r host || [[ -n ${host} ]]; do
		[[ -z ${host} ]] && continue
		[[ ${host} =~ ^[[:space:]]*# ]] && continue
		host=$(echo "${host}" | xargs)
		[[ -z ${host} ]] && continue

		if ping -c 1 ${PING_TIMEOUT_FLAG} 2 "${host}" >/dev/null 2>&1; then
			status_color="${C_GREEN}"
		else
			status_color="${C_RED}"
		fi

		if [[ -n ${output} ]]; then
			output="${output} "
		fi
		output="${output}${status_color}${host}${C_RESET}"
	done < "${CONFIG_FILE}"

	printf "%s" "${output}" > "${CACHE_FILE}"
	chmod 644 "${CACHE_FILE}"
}

update_network_cache
