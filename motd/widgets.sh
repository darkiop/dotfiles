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
	local backend_state self_ip exit_node_ip peer_count output
	backend_state=$(printf "%s" "${status_json}" | jq -r '.BackendState // empty')

	# Show status if not running
	if [[ ${backend_state} != "Running" ]]; then
		output="${backend_state:-stopped}"
		_motd_cache_write "${cache_file}" "${output}"
		printf "%s" "${output}"
		return 0
	fi

	# Get own IP
	self_ip=$(printf "%s" "${status_json}" | jq -r '.Self.TailscaleIPs[0] // empty')

	# Count online peers (excluding self)
	peer_count=$(printf "%s" "${status_json}" | jq '[.Peer[] | select(.Online == true)] | length')

	# Check for exit node
	exit_node_ip=$(printf "%s" "${status_json}" | jq -r '.ExitNodeStatus.TailscaleIPs[0] // empty')

	# Build output
	if [[ -n ${self_ip} ]]; then
		output="${self_ip}"
		if [[ ${peer_count} -gt 0 ]]; then
			output="${output}, ${peer_count} peers"
		fi
		if [[ -n ${exit_node_ip} ]]; then
			output="${output}, exit: ${exit_node_ip}"
		fi
	else
		return 1
	fi

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
	wg_bin=$(command -v wg 2>/dev/null) || return 1

	# Check if any WireGuard interfaces exist (no sudo needed)
	local wg_ifaces
	wg_ifaces=$(ip link show type wireguard 2>/dev/null | grep -oP '^\d+: \K[^:@]+')

	if [[ -z ${wg_ifaces} ]]; then
		# No WireGuard interfaces exist
		return 1
	fi

	# Try to get detailed WireGuard status (may need sudo)
	local wg_output wg_exit

	if [[ ${EUID} -eq 0 ]]; then
		wg_output=$("${wg_bin}" show 2>/dev/null)
		wg_exit=$?
	elif command -v sudo >/dev/null 2>&1; then
		wg_output=$(sudo -n "${wg_bin}" show 2>/dev/null)
		wg_exit=$?
	fi

	# Get interface count and first interface IP
	local interfaces first_iface wg_ip
	interfaces=$(printf "%s\n" "${wg_ifaces}" | grep -c .)
	first_iface=$(printf "%s" "${wg_ifaces}" | head -1)

	if [[ -n ${first_iface} ]]; then
		wg_ip=$(ip -4 addr show "${first_iface}" 2>/dev/null | awk '/inet / {split($2, a, "/"); print a[1]; exit}')
	fi

	# If we have detailed wg output, count peers
	local total_peers active_peers
	total_peers=0
	active_peers=0

	if [[ ${wg_exit} -eq 0 && -n ${wg_output} ]]; then
		total_peers=$(printf "%s" "${wg_output}" | grep -c "^peer:")

		# Count active peers (handshake within last 3 minutes = 180 seconds)
		local handshake_line handshake_ago
		while IFS= read -r handshake_line; do
			if [[ ${handshake_line} =~ ([0-9]+)\ (second|minute|hour|day)s?\ ago ]]; then
				local num="${BASH_REMATCH[1]}"
				local unit="${BASH_REMATCH[2]}"
				case "${unit}" in
					second) handshake_ago="${num}" ;;
					minute) handshake_ago=$((num * 60)) ;;
					hour)   handshake_ago=$((num * 3600)) ;;
					day)    handshake_ago=$((num * 86400)) ;;
				esac
				if [[ ${handshake_ago} -lt 180 ]]; then
					((active_peers++))
				fi
			fi
		done <<< "$(printf "%s" "${wg_output}" | grep "latest handshake:")"
	fi

	# Build output
	local output=""

	# Add IP if available
	if [[ -n ${wg_ip} ]]; then
		output="${wg_ip}"
	fi

	# Add tunnel count
	if [[ ${interfaces} -eq 1 ]]; then
		if [[ -n ${output} ]]; then
			output="${output}, 1 tunnel"
		else
			output="1 tunnel"
		fi
	else
		if [[ -n ${output} ]]; then
			output="${output}, ${interfaces} tunnels"
		else
			output="${interfaces} tunnels"
		fi
	fi

	if [[ ${total_peers} -gt 0 ]]; then
		output="${output}, ${active_peers}/${total_peers} peers active"
	fi

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
