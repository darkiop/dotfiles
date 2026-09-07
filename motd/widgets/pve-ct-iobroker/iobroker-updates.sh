#!/bin/bash
# ioBroker Updates Widget for host pve-ct-iobroker
# Shows repository and count of available updates
# Output format: label:value (required by motd_run_widgets host-specific loader)

set -euo pipefail

# Check if iobroker command is available
if ! command -v iobroker >/dev/null 2>&1; then
	exit 1
fi

# Get update info
update_output=$(iobroker update 2>/dev/null)

if [[ -z ${update_output} ]]; then
	exit 1
fi

# Extract repository name (e.g., "Used repository: beta" -> "beta")
repo=$(printf "%s" "${update_output}" | grep -oP 'Used repository:\s*\K\S+' | head -1 || true)
repo="${repo:-unknown}"

# Count updatable adapters
# grep -c exits 1 when it counts zero, which pipefail would turn into a failure
update_count=$(printf "%s" "${update_output}" | grep -c '\[Updatable\]' || true)
update_count="${update_count:-0}"

# Build output
if [[ ${update_count} -eq 0 ]]; then
	output="${repo}, up to date"
else
	output="${repo}, ${update_count} updates"
fi

printf "iobroker-updates:%s" "${output}"
