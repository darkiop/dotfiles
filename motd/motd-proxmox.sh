#!/bin/bash

TIMEOUT_BIN="$(command -v timeout 2>/dev/null || true)"

_motd_run() {
	if [[ -n ${TIMEOUT_BIN} ]]; then
		"${TIMEOUT_BIN}" 2s "$@" 2>/dev/null
	else
		"$@" 2>/dev/null
	fi
}

_motd_systemctl_is_active() {
	if command -v systemctl >/dev/null 2>&1; then
		_motd_run systemctl is-active "$1" || true
	else
		printf '%s' "unknown"
	fi
}

# systemd
WATCHDOG="$(_motd_systemctl_is_active watchdog-mux.service)"
if [ "${WATCHDOG}" = "active" ]; then 
    systemctl_watchdog_mux=$COLOR_GREEN"watchdog-mux"$COLOR_CLOSE$COLOR_YELLOW
else 
    systemctl_watchdog_mux=$COLOR_RED"watchdog-mux"$COLOR_CLOSE$COLOR_YELLOW
fi
COROSYNC="$(_motd_systemctl_is_active corosync.service)"
if [ "${COROSYNC}" = "active" ]; then 
    systemctl_corosync=$COLOR_GREEN"corosync"$COLOR_CLOSE$COLOR_YELLOW
else 
    systemctl_corosync=$COLOR_RED"corosync"$COLOR_CLOSE$COLOR_YELLOW
fi
PVEHACRM="$(_motd_systemctl_is_active pve-ha-crm.service)"
if [ "${PVEHACRM}" = "active" ]; then 
    systemctl_pvehacrm=$COLOR_GREEN"pve-ha-crm"$COLOR_CLOSE$COLOR_YELLOW
else 
    systemctl_pvehacrm=$COLOR_RED"pve-ha-crm"$COLOR_CLOSE$COLOR_YELLOW
fi

# MOTD
PVE_VERSION="$(_motd_run pveversion || true)"
echo -e " "$COLOR_BLUE"Proxmox   "$COLOR_CLOSE`echo -e "$COLOR_GREEN${PVE_VERSION:-unknown}$COLOR_CLOSE"`
echo
echo -e " "$COLOR_LIGHT_BLUE"Services"$COLOR_CLOSE
echo
echo -e " "$systemctl_watchdog_mux" "$systemctl_corosync" "$systemctl_pvehacrm
echo
echo -e " "$COLOR_LIGHT_BLUE"LXC"$COLOR_CLOSE
if command -v pct >/dev/null 2>&1; then
	PCT_LIST="$(_motd_run pct list || true)"
	if [ "$(printf '%s\n' "${PCT_LIST}" | sed '1d' | wc -l)" -gt 0 ]; then
		echo
		echo -e " "$COLOR_YELLOW"`printf '%s\n' "${PCT_LIST}" | sed -e 's/^[ \t]*//' | sed '1d' | sed "s,.*,$(echo -e $COLOR_YELLOW)&$COLOR_CLOSE," | sed "s,running,$(echo -e $COLOR_GREEN)&$COLOR_CLOSE," | sed "s,stopped,$(echo -e $COLOR_RED)&$COLOR_CLOSE,"`"$COLOR_CLOSE | awk '{print $1,$3,$2}' | sed -e's/  */ /g' | sed 's/^/ /'
	else
		echo
		echo -e " "$COLOR_YELLOW"No LXC is running."$COLOR_CLOSE
	fi
else
	echo
	echo -e " "$COLOR_YELLOW"pct not found."$COLOR_CLOSE
fi
echo
echo -e " "$COLOR_LIGHT_BLUE"QEMU"$COLOR_CLOSE
if command -v qm >/dev/null 2>&1; then
	QM_LIST="$(_motd_run qm list || true)"
	if [ "$(printf '%s\n' "${QM_LIST}" | sed '1d' | wc -l)" -gt 0 ]; then
		echo
		echo -e " "$COLOR_YELLOW"`printf '%s\n' "${QM_LIST}" | sed -e 's/^[ \t]*//' | sed '1d' | sed "s,.*,$(echo -e $COLOR_YELLOW)&$COLOR_CLOSE," | sed "s,running,$(echo -e $COLOR_GREEN)&$COLOR_CLOSE," | sed "s,stopped,$(echo -e $COLOR_RED)&$COLOR_CLOSE,"`"$COLOR_CLOSE | awk '{print $1,$2,$3}' | sed -e's/  */ /g' | sed 's/^/ /'
	else
		echo
		echo -e " "$COLOR_YELLOW"No VM is running."$COLOR_CLOSE
	fi
else
	echo
	echo -e " "$COLOR_YELLOW"qm not found."$COLOR_CLOSE
fi

#EOF
