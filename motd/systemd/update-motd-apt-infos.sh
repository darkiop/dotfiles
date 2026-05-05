#!/bin/bash

set -euo pipefail

OUTPUT_DIR="/usr/local/share/dotfiles"
COUNT_FILE="${OUTPUT_DIR}/apt-updates-count"
PKG_FILE="${OUTPUT_DIR}/apt-updates-packages"

update_apt_info_files() {
	if ! command -v apt-get >/dev/null 2>&1; then
		echo "apt-get not found; skipping MOTD apt cache update" >&2
		return 0
	fi

	mkdir -p "${OUTPUT_DIR}"
	# trunk-ignore(shellcheck/SC2312)
	apt-get -s -o Debug::NoLocking=true upgrade | grep -c ^Inst >"${COUNT_FILE}"
	# trunk-ignore(shellcheck/SC2312)
	apt-get -s dist-upgrade | awk '/^Inst/ { print $2 }' >"${PKG_FILE}"
	chmod 644 "${COUNT_FILE}" "${PKG_FILE}"
	chmod 755 "${OUTPUT_DIR}"
}

update_apt_info_files

cat "${COUNT_FILE}"
cat "${PKG_FILE}"

# EOF
