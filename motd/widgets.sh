#!/bin/bash
# MOTD Widget System (P021)
# Extensible widget architecture for displaying additional system information

# Source local settings if not already loaded (for standalone motd.sh calls)
if [[ -z ${DOTFILES_ENABLE_NETWORK_WIDGET+x} && -f "${HOME}/dotfiles/config/local_dotfiles_settings" ]]; then
	# shellcheck source=/dev/null
	source "${HOME}/dotfiles/config/local_dotfiles_settings"
fi

# Widget cache directory
MOTD_CACHE_DIR="${HOME}/.cache/dotfiles/motd"
mkdir -p "${MOTD_CACHE_DIR}" 2>/dev/null || true

# Helper: Check if cache is fresh
_motd_cache_fresh() {
	local cache_file="$1"
	local max_age_seconds="$2"

	if [[ ! -f ${cache_file} ]]; then
		return 1
	fi

	local now file_mtime age
	# Use EPOCHSECONDS (Bash 5+/Zsh) to avoid spawning date subprocess
	now=${EPOCHSECONDS:-$(date +%s)}
	file_mtime=$(stat -c %Y "${cache_file}" 2>/dev/null || stat -f %m "${cache_file}" 2>/dev/null || echo "0")
	age=$((now - file_mtime))

	[[ ${age} -lt ${max_age_seconds} ]]
}

# Helper: Read from cache
_motd_cache_read() {
	local cache_file="$1"
	if [[ -f ${cache_file} ]]; then
		command cat "${cache_file}"
	fi
}

# Helper: Write to cache
_motd_cache_write() {
	local cache_file="$1"
	local content="$2"
	printf "%s" "${content}" > "${cache_file}" 2>/dev/null || true
}

# ============================================================================
# Docker Widget
# ============================================================================
_motd_widget_docker() {
	local cache_file="${MOTD_CACHE_DIR}/docker"
	local cache_ttl=60

	# Return cached if fresh
	if _motd_cache_fresh "${cache_file}" "${cache_ttl}"; then
		_motd_cache_read "${cache_file}"
		return 0
	fi

	# Command availability is pre-checked by motd_run_widgets

	# Get docker stats (suppress errors if docker daemon not running)
	local running stopped total output
	if ! running=$(docker ps -q 2>/dev/null | wc -l | tr -d ' '); then
		return 1
	fi
	if ! stopped=$(docker ps -aq --filter "status=exited" 2>/dev/null | wc -l | tr -d ' '); then
		stopped=0
	fi
	total=$((running + stopped))

	if [[ ${total} -eq 0 ]]; then
		return 1
	fi

	output="${running} running, ${stopped} stopped (${total} total)"

	# Cache and return
	_motd_cache_write "${cache_file}" "${output}"
	printf "%s" "${output}"
}

# ============================================================================
# Tailscale Widget
# ============================================================================
_motd_widget_tailscale() {
	local cache_file="${MOTD_CACHE_DIR}/tailscale"
	local cache_ttl=60

	# Return cached if fresh
	if _motd_cache_fresh "${cache_file}" "${cache_ttl}"; then
		_motd_cache_read "${cache_file}"
		return 0
	fi

	# Command availability is pre-checked by motd_run_widgets

	# Get tailscale status (JSON for reliable parsing)
	local status_json
	if ! status_json=$(tailscale status --json 2>/dev/null); then
		return 1
	fi

	# Check if jq is available for JSON parsing (use cached check)
	if ! _motd_has_cmd jq; then
		# Fallback: simple status check without jq
		local ip output
		ip=$(tailscale ip -4 2>/dev/null | head -1)
		if [[ -n ${ip} ]]; then
			output="${ip}"
		else
			output="stopped"
		fi
		_motd_cache_write "${cache_file}" "${output}"
		printf "%s" "${output}"
		return 0
	fi

	# Parse status with jq
	local backend_state self_ip output
	backend_state=$(printf "%s" "${status_json}" | jq -r '.BackendState // empty')

	# Show status if not running
	if [[ ${backend_state} != "Running" ]]; then
		output="${backend_state:-stopped}"
		_motd_cache_write "${cache_file}" "${output}"
		printf "%s" "${output}"
		return 0
	fi

	# Get own IP only
	self_ip=$(printf "%s" "${status_json}" | jq -r '.Self.TailscaleIPs[0] // empty')

	if [[ -z ${self_ip} ]]; then
		return 1
	fi
	output="${self_ip}"

	# Cache and return
	_motd_cache_write "${cache_file}" "${output}"
	printf "%s" "${output}"
}

# ============================================================================
# WireGuard Widget
# ============================================================================
_motd_widget_wireguard() {
	local cache_file="${MOTD_CACHE_DIR}/wireguard"
	local cache_ttl=60

	# Return cached if fresh
	if _motd_cache_fresh "${cache_file}" "${cache_ttl}"; then
		_motd_cache_read "${cache_file}"
		return 0
	fi

	# Command availability is pre-checked by motd_run_widgets
	local wg_bin
	wg_bin=$(type -P wg 2>/dev/null) || return 1

	# Only show wg0 status; if not connected, show a minimal message
	local wg_ip output allowed_ips
	# Strip ANSI escape sequences from ip output (ip may colorize even in pipes)
	wg_ip=$(ip -4 addr show dev wg0 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | awk '/inet / {split($2, a, "/"); print a[1]; exit}')

	if [[ -n ${wg_ip} ]]; then
		output="${wg_ip}"

		# Append allowed IPs if available
		allowed_ips=$("${wg_bin}" show wg0 allowed-ips 2>/dev/null | awk '{$1=""; sub(/^ /,""); print}' | paste -sd ",")
		if [[ -z ${allowed_ips} && ${EUID} -ne 0 ]]; then
			if command -v sudo >/dev/null 2>&1; then
				allowed_ips=$(sudo -n "${wg_bin}" show wg0 allowed-ips 2>/dev/null | awk '{$1=""; sub(/^ /,""); print}' | paste -sd ",")
			fi
		fi
		if [[ -n ${allowed_ips} ]]; then
			output="${output}, allowed: ${allowed_ips}"
		fi
	else
		output="not connected"
	fi

	# Cache and return
	_motd_cache_write "${cache_file}" "${output}"
	printf "%s" "${output}"
}

# ============================================================================
# Proxmox Widget
# ============================================================================
_motd_widget_proxmox() {
	local cache_file="${MOTD_CACHE_DIR}/proxmox"
	local cache_ttl=60

	# Return cached if fresh
	if _motd_cache_fresh "${cache_file}" "${cache_ttl}"; then
		_motd_cache_read "${cache_file}"
		return 0
	fi

	# Command availability is pre-checked by motd_run_widgets

	local lxc_running=0 lxc_total=0 vm_running=0 vm_total=0 output

	# Count LXC containers (running and total)
	if _motd_has_cmd pct; then
		read -r lxc_running lxc_total < <(pct list 2>/dev/null | awk 'NR>1 {total++; if($2=="running") running++} END {print running+0, total+0}')
	fi

	# Count VMs (running and total)
	if _motd_has_cmd qm; then
		read -r vm_running vm_total < <(qm list 2>/dev/null | awk 'NR>1 {total++; if($3=="running") running++} END {print running+0, total+0}')
	fi

	# Build output (running/total format)
	output="${lxc_running}/${lxc_total} lxc, ${vm_running}/${vm_total} vm"

	# Cache and return
	_motd_cache_write "${cache_file}" "${output}"
	printf "%s" "${output}"
}

# ============================================================================
# Proxmox IDs Widget (colored by status)
# ============================================================================
_motd_widget_proxmox_ids() {
	local cache_file="${MOTD_CACHE_DIR}/proxmox_ids"
	local cache_ttl=60

	if _motd_cache_fresh "${cache_file}" "${cache_ttl}"; then
		_motd_cache_read "${cache_file}"
		return 0
	fi

	local c_green=$'\x1b[38;5;83m'
	local c_red=$'\x1b[38;5;196m'
	local c_reset=$'\x1b[m'
	local output=""
	local vmid status color
	local -a instances=()

	# Collect LXC containers (pct list: VMID in $1, Status in $2)
	if _motd_has_cmd pct; then
		while read -r vmid status _; do
			[[ -z ${vmid} ]] && continue
			instances+=("${vmid}:${status}")
		done < <(pct list 2>/dev/null | awk 'NR>1 {print $1, $2}')
	fi

	# Collect VMs (qm list: VMID in $1, Status in $3)
	if _motd_has_cmd qm; then
		while read -r vmid status _; do
			[[ -z ${vmid} ]] && continue
			instances+=("${vmid}:${status}")
		done < <(qm list 2>/dev/null | awk 'NR>1 {print $1, $3}')
	fi

	# Sort by ID (numerically) and build colored output
	while IFS=: read -r vmid status; do
		if [[ ${status} == "running" ]]; then
			color="${c_green}"
		else
			color="${c_red}"
		fi
		output="${output}${color}${vmid}${c_reset} "
	done < <(printf '%s\n' "${instances[@]}" | sort -t: -k1 -n)

	# Trim trailing space
	output="${output% }"

	[[ -z ${output} ]] && return 1

	_motd_cache_write "${cache_file}" "${output}"
	printf "%s" "${output}"
}

# ============================================================================
# Homebrew Widget (macOS)
# ============================================================================
_motd_widget_brew() {
	local cache_file="${MOTD_CACHE_DIR}/brew"
	local cache_ttl=3600  # 1 hour - brew outdated is slow

	# Return cached if fresh
	if _motd_cache_fresh "${cache_file}" "${cache_ttl}"; then
		_motd_cache_read "${cache_file}"
		return 0
	fi

	# Command availability is pre-checked by motd_run_widgets

	# Count outdated formulas and casks separately (suppress auto-update)
	local formula_count cask_count total output
	formula_count=$(HOMEBREW_NO_AUTO_UPDATE=1 brew outdated --formula 2>/dev/null | wc -l | tr -d ' ')
	cask_count=$(HOMEBREW_NO_AUTO_UPDATE=1 brew outdated --cask 2>/dev/null | wc -l | tr -d ' ')
	total=$((formula_count + cask_count))

	# Show "up2date" if no updates available
	if [[ ${total} -eq 0 ]]; then
		_motd_cache_write "${cache_file}" "up2date"
		printf "up2date"
		return 0
	fi

	# Build output: "X updates (Y formulas, Z casks)" or simpler variants
	if [[ ${formula_count} -gt 0 && ${cask_count} -gt 0 ]]; then
		output="${total} updates (${formula_count} formulas, ${cask_count} casks)"
	elif [[ ${formula_count} -gt 0 ]]; then
		if [[ ${formula_count} -eq 1 ]]; then
			output="1 formula update"
		else
			output="${formula_count} formula updates"
		fi
	else
		if [[ ${cask_count} -eq 1 ]]; then
			output="1 cask update"
		else
			output="${cask_count} cask updates"
		fi
	fi

	# Cache and return
	_motd_cache_write "${cache_file}" "${output}"
	printf "%s" "${output}"
}

# ============================================================================
# Network Status Widget
# ============================================================================
_motd_widget_network() {
	# Check feature flag first
	if [[ ${DOTFILES_ENABLE_NETWORK_WIDGET:-false} != true ]]; then
		return 1
	fi

	local cache_file="${MOTD_CACHE_DIR}/network"
	local cache_ttl=300  # 5 minutes - systemd updates more frequently

	# Return cached if fresh
	if _motd_cache_fresh "${cache_file}" "${cache_ttl}"; then
		_motd_cache_read "${cache_file}"
		return 0
	fi

	# Config file path
	local config_file="${HOME}/dotfiles/config/network-hosts.conf"
	if [[ ! -f ${config_file} ]]; then
		return 1
	fi

	# Color codes (hardcoded - dotfiles.config uses non-interpreted escapes)
	local c_green=$'\x1b[38;5;83m'
	local c_red=$'\x1b[38;5;196m'
	local c_reset=$'\x1b[m'

	# Platform-specific ping timeout flag
	local ping_timeout_flag="-W"
	if [[ ${DOTFILES_OS:-} == "darwin" ]]; then
		ping_timeout_flag="-t"
	fi

	local output=""
	local host status_color status_symbol

	while IFS= read -r host || [[ -n ${host} ]]; do
		# Skip empty lines and comments
		[[ -z ${host} ]] && continue
		[[ ${host} =~ ^[[:space:]]*# ]] && continue
		# Trim whitespace
		host=$(echo "${host}" | xargs)
		[[ -z ${host} ]] && continue

		# Check reachability (quick ping, 1 second timeout)
		if ping -c 1 ${ping_timeout_flag} 1 "${host}" >/dev/null 2>&1; then
			status_color="${c_green}"
		else
			status_color="${c_red}"
		fi

		# Append to output
		if [[ -n ${output} ]]; then
			output="${output} "
		fi
		output="${output}${status_color}${host}${c_reset}"
	done < "${config_file}"

	if [[ -z ${output} ]]; then
		return 1
	fi

	# Cache and return
	_motd_cache_write "${cache_file}" "${output}"
	printf "%s" "${output}"
}

# ============================================================================
# Widget Runner - Call all enabled widgets
# ============================================================================

# Pre-check available commands once (avoids repeated command -v calls)
declare -A _motd_cmd_available 2>/dev/null || true
_motd_init_cmd_cache() {
	local cmd
	for cmd in docker tailscale wg pveversion pct qm brew jq; do
		if command -v "${cmd}" >/dev/null 2>&1; then
			_motd_cmd_available[${cmd}]=1
		fi
	done
}

# Helper to check cached command availability
_motd_has_cmd() {
	[[ ${_motd_cmd_available[$1]:-} == 1 ]]
}

motd_run_widgets() {
	local widget_output

	# Initialize command cache once
	_motd_init_cmd_cache

	# Docker widget
	if _motd_has_cmd docker; then
		if widget_output=$(_motd_widget_docker 2>/dev/null); then
			print_kv "docker" "${widget_output}"
		fi
	fi

	# Tailscale widget
	if _motd_has_cmd tailscale; then
		if widget_output=$(_motd_widget_tailscale 2>/dev/null); then
			print_kv "tailscale" "${widget_output}"
		fi
	fi

	# WireGuard widget
	if _motd_has_cmd wg; then
		if widget_output=$(_motd_widget_wireguard 2>/dev/null); then
			print_kv "wireguard" "${widget_output}"
		fi
	fi

	# Proxmox widget
	if _motd_has_cmd pveversion; then
		if widget_output=$(_motd_widget_proxmox 2>/dev/null); then
			print_kv "proxmox-overview" "${widget_output}"
		fi
	fi

	# Proxmox instances widget (show all IDs with status colors)
	if _motd_has_cmd pveversion; then
		if widget_output=$(_motd_widget_proxmox_ids 2>/dev/null); then
			print_kv "proxmox-ids" "${widget_output}"
		fi
	fi

	# Homebrew widget (macOS)
	if _motd_has_cmd brew; then
		if widget_output=$(_motd_widget_brew 2>/dev/null); then
			print_kv "homebrew" "${widget_output}"
		fi
	fi

	# Network status widget
	if widget_output=$(_motd_widget_network 2>/dev/null); then
		print_kv "network" "${widget_output}"
	fi

	# Host-specific widgets (if directory exists)
	local hostname
	hostname=$(hostname)
	local host_widgets_dir="${HOME}/dotfiles/motd/widgets/${hostname}"

	if [[ -d ${host_widgets_dir} ]]; then
		for widget_script in "${host_widgets_dir}"/*.sh; do
			if [[ -f ${widget_script} && -x ${widget_script} ]]; then
				# Source or execute widget script
				# Widget scripts should output in format: "label:value"
				if widget_output=$("${widget_script}" 2>/dev/null); then
					if [[ -n ${widget_output} && ${widget_output} == *:* ]]; then
						local label="${widget_output%%:*}"
						local value="${widget_output#*:}"
						print_kv "${label}" "${value}"
					fi
				fi
			fi
		done
	fi
}
