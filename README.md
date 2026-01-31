# my.dotfiles

Personal bash and zsh dotfiles with modular components, git submodules for vim/tmux/fzf, and per-host feature flags. Built for Debian/Ubuntu, works on macOS with some manual setup.

## Installation

### Quick install (interactive menu)

```bash
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')"
```

No curl? Use wget:

```bash
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')"
```

### Non-interactive install

```bash
# Install everything
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')" '' all

# Install and source bashrc immediately
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')" '' all load-bashrc
```

### Manual clone

```bash
git clone --recurse-submodules --shallow-submodules https://github.com/darkiop/dotfiles ~/dotfiles
bash ~/dotfiles/install.sh
```

## Requirements

- **Shell:** bash or zsh
- **Distro:** Debian/Ubuntu (installer uses apt). Other distros or macOS need manual package installation.
- **Tools:** git, curl — the installer can install missing deps via apt if you have sudo.
- **Checklist:** See `install-checklist.md` for details.

### macOS notes

The installer doesn't use Homebrew, so install dependencies yourself:

```bash
brew install git curl jq tmux coreutils reattach-to-user-namespace gawk
```

A few things to keep in mind:
- `coreutils` gives you `gdircolors` and `greadlink` (needed by prompts and dot doctor)
- `gawk` makes fzf tab-completion work properly in zsh
- Anything that needs systemd or journalctl (MOTD timers, `jctl`, systemctl pickers) won't work on macOS

## What's included

**Shell configs:**
- Bash: `bashrc`, `bash_profile`, `inputrc`, `dircolors`
- Zsh: `zshrc`, `zprofile`
- Git: `gitconfig` (sources `~/.gitconfig.local` for your personal settings)

**Custom prompts** (bash and zsh):
- Two-line prompt showing time, user/host, current directory, git status
- SSH indicator when connected remotely
- Shows IP address for easy identification
- Exit code coloring — red when the last command failed
- Sudo ticket indicator

**FZF integrations:**
- History picker (`fh`), directory picker (`cdf`)
- Tab completion with fzf preview
- Git helpers: `gco`, `gshow`, `gaddp`, `gstashp`, `gfixup`, `gcp`
- SSH host picker (`sshp`) with <kbd>Ctrl</kbd>+<kbd>S</kbd> binding
- Tmux session/window/pane pickers (`ts`, `tw`, `tp`)
- Docker helpers: `dps`, `dexec`, `dlogs`
- Systemctl manager: `sctl`
- Journalctl picker: `jctl`
- macOS log picker: `lctl`

**Helpers:**
- `dcheat`, `cheat`, `helpme` — local cheat sheets with fallback to cheat.sh and tldr
- `dot doctor` — quick diagnostics for common issues
- `dot help` — overview of available commands and keybindings
- Navi cheat widget (<kbd>Ctrl</kbd>+<kbd>G</kbd>)
- Archive extraction for various formats

**Tmux:**
- oh-my-tmux + TPM (Tmux Plugin Manager)
- Local config in `config/tmux.conf.local`

**MOTD (Message of the Day):**
- Hostname-based scripts for different machines
- Widget system for docker, tailscale, wireguard, proxmox, homebrew, network status
- Optional systemd timers for background updates

## Feature flags

All flags default to `true` unless noted. You can override them per-host by creating `~/dotfiles/config/local_dotfiles_settings` (gitignored):

```bash
DOTFILES_ENABLE_AUTOUPDATE=false
DOTFILES_ENABLE_TMUX_AUTOSTART=false
DOTFILES_ENABLE_SSH_TMUX_RENAME=false
```

### Available flags

| Flag | Default | Description |
|------|---------|-------------|
| `DOTFILES_ENABLE_PROMPT` | true | Custom bash/zsh prompt |
| `DOTFILES_ENABLE_BASH_COMPLETION` | true | Bash completions |
| `DOTFILES_ENABLE_FZF` | true | FZF integration |
| `DOTFILES_ENABLE_FZF_TAB_COMPLETION` | true | FZF-based tab completion |
| `DOTFILES_ENABLE_FZF_EXTRAS` | true | fh and cdf functions |
| `DOTFILES_ENABLE_FZF_HISTORY_BINDINGS` | true | <kbd>Ctrl</kbd>+<kbd>R</kbd> for fh picker |
| `DOTFILES_ENABLE_FZF_CDF_BINDING` | true | <kbd>Alt</kbd>+<kbd>C</kbd> for cdf picker |
| `DOTFILES_ENABLE_GIT_FZF` | true | Git fzf helpers |
| `DOTFILES_ENABLE_DOCKER_FZF` | true | Docker fzf helpers |
| `DOTFILES_ENABLE_TMUX_FZF` | true | Tmux fzf pickers |
| `DOTFILES_ENABLE_SYSTEMCTL_FZF` | true | Systemctl fzf manager |
| `DOTFILES_ENABLE_JOURNALCTL_PICKER` | true | Journalctl picker |
| `DOTFILES_ENABLE_LOG_PICKER` | true (macOS) | macOS log picker |
| `DOTFILES_ENABLE_SSH_PICKER` | true | SSH host picker |
| `DOTFILES_ENABLE_NAVI` | true | Navi cheatsheet widget |
| `DOTFILES_ENABLE_ALIASES` | true | Load alias files |
| `DOTFILES_ENABLE_HELPERS` | true | Helper functions |
| `DOTFILES_ENABLE_EXTRACT_EXT` | true | Extended archive extraction |
| `DOTFILES_ENABLE_DOT_DOCTOR` | true | Diagnostics command |
| `DOTFILES_ENABLE_DOT_HELP` | true | Help system |
| `DOTFILES_ENABLE_DOT_HELP_BINDING` | true | <kbd>Ctrl</kbd>+<kbd>H</kbd> opens dot help |
| `DOTFILES_ENABLE_RELOAD_BINDING` | true | <kbd>Alt</kbd>+<kbd>R</kbd> reloads shell |
| `DOTFILES_ENABLE_BREW` | true | Homebrew integration |
| `DOTFILES_ENABLE_OH_MY_ZSH` | false | Oh My Zsh framework |
| `DOTFILES_ENABLE_MOTD` | false | MOTD components |
| `DOTFILES_ENABLE_MOTD_AUTO_RUN` | false | Auto-show MOTD on login |
| `DOTFILES_ENABLE_MOTD_WIDGETS` | true | MOTD widget system |
| `DOTFILES_ENABLE_NETWORK_WIDGET` | false | Network reachability widget |
| `DOTFILES_ENABLE_AUTOUPDATE` | true | Auto-update dotfiles |
| `DOTFILES_ENABLE_TMUX_AUTOSTART` | true | Auto-start tmux |
| `DOTFILES_ENABLE_SSH_TMUX_RENAME` | true | Rename tmux window on SSH |
| `DOTFILES_ENABLE_IOBROKER` | true | ioBroker integrations |
| `DOTFILES_MOTD_STYLE` | tree | MOTD layout: "tree" or "default" |

## Prompt

The prompt is two lines:

```
┌[12:34:56] [ssh:user🤘host (192.168.1.1): ~/projects (755)] [git:main *+] [sudo]
└─$
```

The line characters (`┌`/`└─`) turn red when the previous command failed. The separator between user and host is `🤘` (or `💀` for root).

**What each part shows:**
- Time in HH:MM:SS
- SSH indicator (only when connected remotely)
- Username and hostname
- IP address (filtered to show your main address, not localhost or link-local)
- Current directory with permissions
- Git branch with status indicators: `+` (staged), `*` (dirty), `$` (stash), `%` (untracked)
- Upstream status: `=` (synced), `>` (ahead), `<` (behind), `<>` (diverged)
- Sudo indicator when your sudo ticket is active

Both bash and zsh use the same layout. Bash relies on `__git_ps1` while zsh has its own git status implementation.

**Note:** There's a startup fix that flushes stray terminal responses (like OSC 11 color queries) to prevent garbage in your prompt.

## Git + FZF helpers

Pick branches, commits, files interactively with fzf:

| Command | Action |
|---------|--------|
| `gco` | Pick a branch/tag and checkout |
| `gshow` | Pick a commit and show it |
| `gaddp` | Pick modified files and stage them |
| `gstashp show\|apply\|pop\|drop` | Pick a stash and run the action |
| `gfixup` | Pick a commit for fixup |
| `gcp` | Pick a commit and copy its hash to clipboard |

Clipboard support uses `wl-copy`, `xclip`, or `pbcopy` depending on your system.

## SSH picker

Pick SSH hosts from your `~/.ssh/config`:

| Command | Keybinding | Action |
|---------|------------|--------|
| `sshp` | <kbd>Ctrl</kbd>+<kbd>S</kbd> | Pick a host and connect |

The picker shows all configured hosts and connects to your selection.

## Tmux picker

Navigate tmux sessions, windows, and panes with fzf:

| Command | Keybinding | Action |
|---------|------------|--------|
| `ts` | — | Pick a session and switch |
| `tw` | <kbd>Ctrl</kbd>+<kbd>F</kbd> | Pick a window and focus it |
| `tp` | — | Pick a pane and focus it |

## journalctl picker

View systemd service logs:

| Command | Action |
|---------|--------|
| `jctl` | Pick a service and view last 500 log lines |
| `jctl follow` | Pick a service and follow logs |

## systemctl manager

Interactive service management:

| Command | Action |
|---------|--------|
| `sctl` | Pick a service, see status/logs, start/stop/restart |

The preview shows current status and recent logs. Actions like start/stop automatically use sudo when needed.

## macOS log picker

View launchd and Homebrew service logs:

| Command | Action |
|---------|--------|
| `lctl` | Pick a service and view logs |
| `lctl follow` | Stream logs in real-time |

Lists services from Homebrew and system LaunchDaemons. Uses macOS Unified Logging for system services and checks common log paths for Homebrew services. Prefers `lnav` for viewing if installed.

## Docker helpers

Manage containers interactively:

| Command | Action |
|---------|--------|
| `dps` | Pick a container and show its status |
| `dexec [cmd]` | Pick a container and exec into it (default: bash) |
| `dlogs` | Pick a container and show last ~500 log lines |
| `dlogs follow` | Follow container logs |

The picker shows container ID, name, image, status, and ports. Falls back to sudo if needed for permissions.

## dot commands

| Command | Alias | Action |
|---------|-------|--------|
| `dot help` | `dot h`, `dot` | Show commands and keybindings |
| `dot help --plain` | — | Force text output (skip fzf) |
| `dot doctor` | — | Run diagnostics |
| `dot reload` | — | Clear screen and reload shell |
| `dot install` | `dot i` | Run installer |
| `dot update` | `dot u` | Pull repo and update submodules |
| `dot cd` | — | cd to ~/dotfiles |
| `dot modules` | `dot mod` | List submodules with sync status |
| `dot env` | — | Show DOTFILES_* environment variables |
| `dot alias` | — | List all aliases with availability check |
| `dot cache remove` | — | Clear MOTD widget cache |

## FZF extras

| Command | Keybinding | Action |
|---------|------------|--------|
| `fh` | <kbd>Ctrl</kbd>+<kbd>R</kbd> | Pick from command history |
| `cdf` | <kbd>Alt</kbd>+<kbd>C</kbd> | Pick a directory and cd |

## FZF tab completion

Press <kbd>Tab</kbd> to get fzf-powered completion with previews. Works in both bash and zsh.

## Navi

Press <kbd>Ctrl</kbd>+<kbd>G</kbd> to open the navi cheat menu. Cheat files are in `cheats/`.

## Helpers

| Command | Action |
|---------|--------|
| `dcheat [query]` | Browse local cheat files with fzf |
| `cheat <topic>` | Show local cheat, fall back to cheat.sh or tldr |
| `helpme <cmd>` | Best available help: local cheat → --help → man |

Set `DOTFILES_CHEATS_DIR` to use a different cheats directory.

## Archive extraction

The `extract` function handles common archive formats: tar.gz, zip, rar, 7z, xz, zstd, and more. It checks for required tools and gives helpful errors if something's missing.

## oh-my-zsh

Disabled by default. Enable with `DOTFILES_ENABLE_OH_MY_ZSH=true`. Loads from the submodule if present. Auto-update and compfix are disabled to avoid prompts.

## MOTD

The message of the day system shows system info on login. Enable with `DOTFILES_ENABLE_MOTD=true` and optionally `DOTFILES_ENABLE_MOTD_AUTO_RUN=true` for automatic display.

**What it shows:**
- Uptime, disk usage (root and home)
- IP address, OS info, load average
- Tasks from `motd/tasks.json`
- APT updates (cached)

**Widgets** (via `DOTFILES_ENABLE_MOTD_WIDGETS`):
- docker — running/stopped container counts
- tailscale — Tailscale IP or status
- wireguard — WireGuard IP and allowed IPs
- proxmox — LXC/VM counts
- homebrew — available updates
- network — reachability status for configured hosts

Add custom widgets in `motd/widgets/<hostname>/`.

**Network widget:** Shows host reachability (green = up, red = down). Enable with `DOTFILES_ENABLE_NETWORK_WIDGET=true` and configure hosts in `config/network-hosts.conf`.

**Layout:** Set `DOTFILES_MOTD_STYLE=tree` for tree layout or `DOTFILES_MOTD_STYLE=default` for simple key-value lines.

**Systemd timers** handle background cache updates for APT info and directory sizes. The installer sets these up automatically on full install. Manual setup:

```bash
sudo cp ~/dotfiles/motd/systemd/*.service ~/dotfiles/motd/systemd/*.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now update-motd-apt-infos.timer calc-dir-size-homes.timer
```

Check timers: `systemctl list-timers | grep -E '(update-motd-apt-infos|calc-dir-size-homes)'`

## Platform detection

The `components/platform` file exports these variables:

- `DOTFILES_OS` — linux, darwin, or unknown
- `DOTFILES_DISTRO_ID`, `DOTFILES_DISTRO_LIKE` — from /etc/os-release
- `DOTFILES_WSL` — 1 if running in WSL
- `DOTFILES_CONTAINER` — 1 if running in a container

## Updating

**Manual:**
```bash
cd ~/dotfiles && git pull --ff-only && git submodule update --init --recursive --depth 1
```

**Automatic:** The `autoupdate.sh` script runs from bashrc after ~20 logins. Disable with `DOTFILES_ENABLE_AUTOUPDATE=false`.

## Troubleshooting

**Line endings:** The `.gitattributes` file enforces LF for shell files. CRLF causes errors like `syntax error near unexpected token $'in\r'`.

**Submodules:** The gitconfig enables `submodule.recurse=true`. If you have SSH-only access without keys, submodule fetch can fail. The autoupdate script disables recursion for its pull.

**Credentials:** Put sensitive Git settings in `~/.gitconfig.local` (signing keys, credential helpers, etc.).

**Diagnostics:** Run `dot doctor` to check for common issues.

## Keyboard bindings

### Shell bindings (bash + zsh)

| Key | Action |
|-----|--------|
| <kbd>Ctrl</kbd>+<kbd>A</kbd> | Jump to beginning of line |
| <kbd>Ctrl</kbd>+<kbd>E</kbd> | Jump to end of line |
| <kbd>Ctrl</kbd>+<kbd>C</kbd> | Interrupt command |
| <kbd>Ctrl</kbd>+<kbd>L</kbd> | Clear screen |
| <kbd>Ctrl</kbd>+<kbd>R</kbd> | History picker (fh) |
| <kbd>Ctrl</kbd>+<kbd>S</kbd> | SSH host picker (sshp) |
| <kbd>Ctrl</kbd>+<kbd>F</kbd> | Tmux window picker (tw) — only inside tmux |
| <kbd>Ctrl</kbd>+<kbd>G</kbd> | Navi cheat menu |
| <kbd>Ctrl</kbd>+<kbd>H</kbd> | Open dot help |
| <kbd>Alt</kbd>+<kbd>C</kbd> | Directory picker (cdf) |
| <kbd>Alt</kbd>+<kbd>R</kbd> | Reload shell (dot reload) |
| <kbd>Tab</kbd> | FZF tab completion |

### tmux bindings

Prefix is <kbd>Ctrl</kbd>+<kbd>a</kbd>.

| Key | Action |
|-----|--------|
| <kbd>Alt</kbd>+<kbd>Arrow</kbd> | Switch to adjacent pane |
| <kbd>Ctrl</kbd>+<kbd>t</kbd> | New window (no prefix needed) |
| <kbd>Shift</kbd>+<kbd>Left</kbd>/<kbd>Right</kbd> | Switch window |
| <kbd>F11</kbd> | Toggle pane fullscreen |
| <kbd>Prefix</kbd> <kbd><</kbd> | Split vertically |
| <kbd>Prefix</kbd> <kbd>-</kbd> | Split horizontally |
| <kbd>Prefix</kbd> <kbd>c</kbd>/<kbd>t</kbd> | New window |
| <kbd>Prefix</kbd> <kbd>w</kbd> | Close window |
| <kbd>Prefix</kbd> <kbd>s</kbd> | Show windows |
| <kbd>Prefix</kbd> <kbd>,</kbd> | Rename window |
| <kbd>Prefix</kbd> <kbd>d</kbd> | Detach session |
| <kbd>Prefix</kbd> <kbd>e</kbd> | Edit tmux.conf.local |
| <kbd>Prefix</kbd> <kbd>Tab</kbd> | Toggle last/current window |
| <kbd>Prefix</kbd> <kbd>z</kbd> | Toggle pane fullscreen |
| <kbd>Prefix</kbd> <kbd>r</kbd> | Reload tmux.conf |
| <kbd>Prefix</kbd> <kbd>?</kbd> | List shortcuts |
| <kbd>Prefix</kbd> <kbd>Ctrl</kbd>+<kbd>s</kbd> | Save tmux environment |
| <kbd>Prefix</kbd> <kbd>Ctrl</kbd>+<kbd>r</kbd> | Restore tmux environment |
| <kbd>Prefix</kbd> <kbd>$</kbd> | Rename session |

## Credits

### Inspiration

- [1995parham/dotfiles](https://github.com/1995parham/dotfiles)
- [denisidoro/dotfiles](https://github.com/denisidoro/dotfiles)

### Tools and projects used

- [koljah-de/simple-bash-prompt](https://github.com/koljah-de/simple-bash-prompt)
- [chubin/cheat.sh](https://github.com/chubin/cheat.sh)
- [denisidoro/navi](https://github.com/denisidoro/navi)
- [Peltoche/lsd](https://github.com/Peltoche/lsd)
- [sharkdp/bat](https://github.com/sharkdp/bat)
- [amix/vimrc](https://github.com/amix/vimrc)
- [mdom/dategrep](https://github.com/mdom/dategrep)
- [lnav](http://lnav.org)
- [gpakosz/.tmux](https://github.com/gpakosz/.tmux)

### More resources

- [dotfiles.github.io/tutorials](https://dotfiles.github.io/tutorials/)
- [junegunn/fzf](https://github.com/junegunn/fzf)
- [tmux/tmux](https://github.com/tmux/tmux)
- [starship/starship](https://github.com/starship/starship)
- [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
- [seebi/dircolors-solarized](https://github.com/seebi/dircolors-solarized)
- [jlevy/the-art-of-command-line](https://github.com/jlevy/the-art-of-command-line)
