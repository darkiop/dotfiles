# MOTD System

## Analogy: A News Ticker Dashboard

Think of the MOTD system like a **smart news ticker** on a digital billboard. When you walk into your building (log into a server), the billboard shows you relevant information: weather, traffic, stock prices. But a billboard in New York shows different info than one in Tokyo. Similarly, your MOTD shows different things depending on which host you're on—Docker stats on a container host, Proxmox VM status on a hypervisor, Homebrew updates on macOS.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          LOGIN / SHELL                               │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         motd/motd.sh                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────────────┐     │
│  │ System Info  │  │  Host Title  │  │   Core Stats Output    │     │
│  │ (uptime, IP, │  │ (toilet/     │  │  ip, load, uptime,     │     │
│  │  disk, load) │  │  ASCII art)  │  │  os, /, /home, tasks   │     │
│  └──────────────┘  └──────────────┘  └────────────────────────┘     │
│                               │                                      │
│                               ▼                                      │
│         if DOTFILES_ENABLE_MOTD_WIDGETS=true                        │
│                    source widgets.sh                                 │
│                    motd_run_widgets()                                │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
        ┌──────────────────────┼──────────────────────┐
        ▼                      ▼                      ▼
┌───────────────┐    ┌─────────────────┐    ┌────────────────────┐
│ Built-in      │    │ Built-in        │    │ Host-specific      │
│ Widgets       │    │ Widgets         │    │ Scripts            │
├───────────────┤    ├─────────────────┤    ├────────────────────┤
│ docker        │    │ tailscale       │    │ motd-proxmox.sh    │
│ proxmox       │    │ wireguard       │    │ motd-odin.sh       │
│ homebrew      │    │ network         │    │ widgets/$HOST/*.sh │
└───────┬───────┘    └────────┬────────┘    └─────────┬──────────┘
        │                     │                       │
        └─────────────────────┴───────────────────────┘
                              │
                              ▼
                    ┌─────────────────────┐
                    │   Cache Layer       │
                    │ ~/.cache/dotfiles/  │
                    │     motd/           │
                    │ (TTL: 60s-3600s)    │
                    └─────────────────────┘
```

## Step-by-Step Walkthrough

### 1. Entry Point: `motd.sh`

The main script gathers **core system info**:

```bash
# Uptime detection (macOS vs Linux differ)
UPTIME_TEXT="$(/usr/bin/uptime -p 2>/dev/null)"

# Disk usage via single df call
ROOT_DF=$(df -h / 2>/dev/null | awk 'NR==2 {print $2, $3, $5}')

# Home size (checks cache first, then df)
if [[ -f /usr/local/share/dotfiles/dir-sizes ]]; then
    USAGE_HOME=$(</usr/local/share/dotfiles/dir-sizes)  # Pre-computed by systemd timer
fi
```

### 2. Platform Detection

IP detection adapts to the OS:

```bash
dotfiles_motd_get_ip() {
    if [[ ${DOTFILES_OS} == "darwin" ]]; then
        ipconfig getifaddr en0  # macOS way
    else
        ip -4 route get 1.1.1.1 | awk '...'  # Linux way
    fi
}
```

### 3. Host-Specific Customization

The hostname drives customization via `case` statements:

```bash
case ${HOSTNAME} in
odin)
    # Synology NAS: custom ASCII art + DSM version
    GET_PLATFORM_DATA="Synology DSM "$(cat /etc.defaults/VERSION ...)
    ;;
*)
    # Default: read /etc/os-release or sw_vers
    ;;
esac
```

### 4. Output Rendering

All output goes through `print_kv()` for consistent formatting:

```bash
print_kv() {
    printf "  %b%-11s%b %b%s%b\n" \
        "${COLOR_BLUE}" "${label}" "${COLOR_RESET}" \
        "${COLOR_GREEN}" "${value}" "${COLOR_RESET}"
}

print_kv ip "192.168.1.100"       # Output:   ip          192.168.1.100
print_kv load "0.5 / 0.3 / 0.2"   # Output:   load        0.5 / 0.3 / 0.2
```

### 5. Widget System: `widgets.sh`

Widgets are **self-contained functions** with a consistent pattern:

```bash
_motd_widget_docker() {
    # 1. Check cache freshness (60 second TTL)
    if _motd_cache_fresh "${cache_file}" 60; then
        _motd_cache_read "${cache_file}"
        return 0
    fi

    # 2. Check if tool exists
    if ! command -v docker >/dev/null 2>&1; then
        return 1  # Silent skip - widget not applicable
    fi

    # 3. Gather data
    running=$(docker ps -q | wc -l)
    stopped=$(docker ps -aq --filter "status=exited" | wc -l)

    # 4. Format output
    output="${running} running, ${stopped} stopped"

    # 5. Cache and return
    _motd_cache_write "${cache_file}" "${output}"
    printf "%s" "${output}"
}
```

### 6. Widget Runner

`motd_run_widgets()` calls each widget and uses `print_kv` for output:

```bash
motd_run_widgets() {
    # Each widget returns 0 (success) only if it has something to show
    if widget_output=$(_motd_widget_docker); then
        print_kv "docker" "${widget_output}"
    fi

    if widget_output=$(_motd_widget_tailscale); then
        print_kv "tailscale" "${widget_output}"
    fi
    # ... more widgets

    # Host-specific widgets from ~/dotfiles/motd/widgets/$HOSTNAME/*.sh
    for widget_script in "${host_widgets_dir}"/*.sh; do
        # Execute and parse "label:value" format
    done
}
```

## Data Flow Example

When you login to a Proxmox host:

```
1. motd.sh runs
2. Gathers: uptime=2 days, IP=10.0.0.5, load=0.3/0.2/0.1
3. Shows ASCII hostname via toilet
4. Prints core stats (ip, load, uptime, os, disk)
5. Calls motd_run_widgets()
   └─ _motd_widget_docker() → "5 running, 2 stopped"
   └─ _motd_widget_proxmox() → "3/4 lxc, 1/2 vm"
   └─ _motd_widget_tailscale() → "100.100.1.5"
6. Output appears as:

      ██████╗ ██╗   ██╗███████╗
      ██╔══██╗██║   ██║██╔════╝
      ██████╔╝██║   ██║█████╗
      ██╔═══╝ ╚██╗ ██╔╝██╔══╝
      ██║      ╚████╔╝ ███████╗
      ╚═╝       ╚═══╝  ╚══════╝

      ip          10.0.0.5
      load        0.30 / 0.20 / 0.10
      uptime      up 2 days
      os          Debian GNU/Linux 12
      /           15G of 50G (30%)
      docker      5 running, 2 stopped
      proxmox     3/4 lxc, 1/2 vm
      tailscale   100.100.1.5
```

## Gotcha: Silent Failures by Design

**Common misconception**: "My widget isn't showing—it must be broken!"

Widgets are designed to **fail silently** when not applicable. If Docker isn't installed, `_motd_widget_docker` returns `1` and outputs nothing. This is intentional—the same `motd.sh` runs everywhere, and widgets self-select based on what's available.

```bash
# This is NOT a bug:
if ! command -v docker >/dev/null 2>&1; then
    return 1  # ← Silent exit, no error message
fi
```

To debug a missing widget, check:
1. Is the tool installed? (`command -v docker`)
2. Is cache stale? (delete `~/.cache/dotfiles/motd/docker`)
3. Is the feature flag enabled? (`DOTFILES_ENABLE_MOTD_WIDGETS=true`)

## File Structure

```
motd/
├── motd.sh              # Main entry point
├── widgets.sh           # Widget system + built-in widgets
├── widgets/             # Host-specific widget scripts
│   └── README.md
├── motd-<hostname>.sh   # Host-specific extensions (e.g., motd-proxmox.sh)
├── tasks.json           # Per-host task messages
└── systemd/             # Timers for cache updates
    ├── calc-dir-size-homes.*
    └── update-motd-apt-infos.*
```

## Built-in Widgets

These widgets come with the MOTD system and activate automatically when the required tools are present:

| Widget | What it shows | Cache TTL | Requirements |
|--------|---------------|-----------|--------------|
| docker | Running/stopped container counts | 60s | `docker` command |
| tailscale | Tailscale IP or status | 300s | `tailscale` command |
| wireguard | WireGuard IP and peer info | 300s | `wg` command |
| proxmox | LXC/VM counts (running/total) | 60s | `pct`, `qm` (Proxmox VE) |
| homebrew | Available updates | 3600s | `brew` command (macOS) |
| network | Host reachability status | 60s | `config/network-hosts.conf` |

The network widget requires explicit opt-in via `DOTFILES_ENABLE_NETWORK_WIDGET=true`.

## Adding a New Widget

1. Add a function `_motd_widget_<name>()` in `widgets.sh`
2. Follow the pattern: cache check → tool check → gather data → format → cache write
3. Register it in `motd_run_widgets()` with `print_kv`
4. Widget should return `1` (silent skip) if not applicable
