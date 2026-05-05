#!/bin/bash
# ioBroker Instances Widget for host pve-ct-iobroker
# Shows all instance names with status colors (green=active, red=inactive)
# Output format: label:value (required by motd_run_widgets host-specific loader)

# Check if iobroker command is available
if ! command -v iobroker >/dev/null 2>&1; then
	exit 1
fi

c_green=$'\x1b[38;5;83m'
c_red=$'\x1b[38;5;196m'
c_reset=$'\x1b[m'
output=""

while IFS= read -r line; do
	# Skip empty lines and the "instance is alive" footer
	[[ -z ${line} ]] && continue
	[[ ${line} == *"instance is alive"* ]] && continue

	# Check if line starts with + (active) or space (inactive)
	if [[ ${line} =~ ^[[:space:]]*\+ ]]; then
		is_active=true
	else
		is_active=false
	fi

	# Extract instance name: second field after first colon, trimmed
	# Format: system.adapter.admin.0  : admin  : hostname  - status
	name=$(printf "%s" "${line}" | awk -F':' '{gsub(/^ +| +$/, "", $2); print $2}')

	[[ -z ${name} ]] && continue

	# Set color based on status
	if [[ ${is_active} == true ]]; then
		output="${output}${c_green}${name}${c_reset} "
	else
		output="${output}${c_red}${name}${c_reset} "
	fi
done < <(iobroker list instances 2>/dev/null)

# Trim trailing space
output="${output% }"

[[ -z ${output} ]] && exit 1

printf "iobroker-instances:%s" "${output}"
