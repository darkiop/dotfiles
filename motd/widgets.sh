#!/bin/bash
# MOTD Widget System (P021)
# Extensible widget architecture for displaying additional system information

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
	now=$(date +%s)
	file_mtime=$(stat -c %Y "${cache_file}" 2>/dev/null || stat -f %m "${cache_file}" 2>/dev/null || echo "0")
	age=$((now - file_mtime))

	[[ ${age} -lt ${max_age_seconds} ]]
}

# Helper: Read from cache
_motd_cache_read() {
	local cache_file="$1"
	if [[ -f ${cache_file} ]]; then
		cat "${cache_file}"
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

	# Check if docker is available
	if ! command -v docker >/dev/null 2>&1; then
		return 1
	fi

	# Get docker stats (suppress errors if docker daemon not running)
	local running stopped total output
	if ! running=$(docker ps -q 2>/dev/null | wc -l); then
		return 1
	fi
	if ! stopped=$(docker ps -aq --filter "status=exited" 2>/dev/null | wc -l); then
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

	# Check if tailscale is available
	if ! command -v tailscale >/dev/null 2>&1; then
		return 1
	fi

	# Get tailscale status (JSON for reliable parsing)
	local status_json
	if ! status_json=$(tailscale status --json 2>/dev/null); then
		return 1
	fi

	# Check if jq is available for JSON parsing
	if ! command -v jq >/dev/null 2>&1; then
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

	# Check if wg is available
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

	# Check if we're on a Proxmox host
	if ! command -v pveversion >/dev/null 2>&1; then
		return 1
	fi

	local lxc_running=0 vm_running=0 output parts=()

	# Count running LXC containers
	if command -v pct >/dev/null 2>&1; then
		lxc_running=$(pct list 2>/dev/null | awk '$2 == "running" {count++} END {print count+0}')
	fi

	# Count running VMs
	if command -v qm >/dev/null 2>&1; then
		vm_running=$(qm list 2>/dev/null | awk '$3 == "running" {count++} END {print count+0}')
	fi

	# Build output
	if [[ ${lxc_running} -gt 0 ]]; then
		parts+=("${lxc_running} lxc")
	fi
	if [[ ${vm_running} -gt 0 ]]; then
		parts+=("${vm_running} vm")
	fi

	# Only show if something is running
	if [[ ${#parts[@]} -eq 0 ]]; then
		return 1
	fi

	output=$(IFS=', '; printf '%s' "${parts[*]}")

	# Cache and return
	_motd_cache_write "${cache_file}" "${output}"
	printf "%s" "${output}"
}

# ============================================================================
# Widget Runner - Call all enabled widgets
# ============================================================================
motd_run_widgets() {
	local widget_output

	# Docker widget
	if widget_output=$(_motd_widget_docker 2>/dev/null); then
		print_kv "docker" "${widget_output}"
	fi

	# Tailscale widget
	if widget_output=$(_motd_widget_tailscale 2>/dev/null); then
		print_kv "tailscale" "${widget_output}"
	fi

	# WireGuard widget
	if widget_output=$(_motd_widget_wireguard 2>/dev/null); then
		print_kv "wireguard" "${widget_output}"
	fi

	# Proxmox widget
	if widget_output=$(_motd_widget_proxmox 2>/dev/null); then
		print_kv "proxmox" "${widget_output}"
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
