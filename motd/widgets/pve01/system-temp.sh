#!/bin/bash
# CPU Temperature Widget for pve01
# Output format: "label:value" (required by widget runner)

set -euo pipefail

# Cache settings
CACHE_DIR="${HOME}/.cache/dotfiles/motd"
CACHE_FILE="${CACHE_DIR}/pve01-temp"
CACHE_TTL=30

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

# Check if inxi is available
if ! command -v inxi >/dev/null 2>&1; then
	exit 1
fi

# Get CPU temperature
temp=$(inxi -s 2>/dev/null | grep -i cpu | awk '{print $4}')

if [[ -z ${temp} ]]; then
	exit 1
fi

# Build output (label:value format)
output="temp:${temp}"

# Cache and output
printf "%s" "${output}" > "${CACHE_FILE}" 2>/dev/null || true
printf "%s\n" "${output}"
