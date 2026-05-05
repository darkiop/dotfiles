#!/bin/bash
# ioBroker Widget for pve-ct-iobroker
# Displays: Node.js/npm version, js-controller status, running instances count
# Output format: "label:value" (required by widget runner)

set -euo pipefail

# Cache settings
CACHE_DIR="${HOME}/.cache/dotfiles/motd"
CACHE_FILE="${CACHE_DIR}/iobroker"
CACHE_TTL=60

mkdir -p "${CACHE_DIR}" 2>/dev/null || true

# Check if cache is fresh
_cache_fresh() {
	local cache_file="$1"
	local max_age="$2"

	[[ -f ${cache_file} ]] || return 1

	local now file_mtime age
	now=$(date +%s)
	file_mtime=$(stat -c %Y "${cache_file}" 2>/dev/null || stat -f %m "${cache_file}" 2>/dev/null || echo "0")
	age=$((now - file_mtime))

	[[ ${age} -lt ${max_age} ]]
}

# Return cached value if fresh
if _cache_fresh "${CACHE_FILE}" "${CACHE_TTL}"; then
	cat "${CACHE_FILE}"
	exit 0
fi

# Check if iobroker is available
IOB_BIN=$(command -v iobroker 2>/dev/null || true)
if [[ -z ${IOB_BIN} || ! -x ${IOB_BIN} ]]; then
	exit 1
fi

# Gather data
node_version=$(node -v 2>/dev/null | tr -d 'v') || node_version="?"
npm_version=$(npm -v 2>/dev/null) || npm_version="?"

# js-controller status via systemctl
js_status="off"
if systemctl is-active --quiet iobroker.service 2>/dev/null; then
	js_status="on"
fi

# Count running instances
# iobroker list instances outputs lines like: "system.adapter.admin.0 : admin - enabled, port: 8081, bind: 0.0.0.0, run as: admin"
# We count lines containing "enabled" as running instances
running_instances=0
if [[ ${js_status} == "on" ]]; then
	# Use iobroker status to get instance count
	# Alternative: parse 'iobroker list instances' output
	instance_list=$(iobroker list instances 2>/dev/null || true)
	if [[ -n ${instance_list} ]]; then
		running_instances=$(echo "${instance_list}" | grep -c "enabled" 2>/dev/null || echo "0")
	fi
fi

# Build output
output="iobroker:node ${node_version}, npm ${npm_version}, js-controller ${js_status}, ${running_instances} instances"

# Cache and output
printf "%s" "${output}" > "${CACHE_FILE}" 2>/dev/null || true
printf "%s\n" "${output}"
