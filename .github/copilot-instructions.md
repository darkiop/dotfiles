**Keep in sync: AGENTS.md, CLAUDE.md, .github/copilot-instructions.md**

## Overview

Personal bash/zsh dotfiles with modular components and submodules. Goals: minimal changes, POSIX-friendly, preserve per-host feature flags.

## Repository Structure

```
dotfiles/
├── alias/              # Shell aliases (9 files by category)
│   ├── alias           # Main aliases (sudo prefixes, global)
│   ├── alias-docker    # Docker commands
│   ├── alias-git       # Git commands
│   ├── alias-systemctl # Systemctl commands
│   ├── alias-proxmox   # Proxmox VE commands
│   ├── alias-wireguard # WireGuard VPN
│   ├── alias-glusterfs # Gluster filesystem
│   ├── alias-iobroker  # ioBroker smart home
│   └── alias-navi      # Navi cheat widget
├── bash_completion.d/  # Custom bash completions
├── bin/                # Helper scripts
├── cheats/             # Navi cheat files (.cheat format)
├── components/         # 22 modular shell components
├── config/             # Configuration files
│   ├── dotfiles.config       # Colors and global settings
│   ├── local_dotfiles_settings # Per-host overrides (gitignored)
│   ├── dot_help.json         # Database for `dot help`
│   ├── tmux.conf.local       # Tmux local overrides
│   └── helix/                # Helix editor config
├── modules/            # Git submodules (shallow)
│   ├── fzf/            # Fuzzy finder
│   ├── fzf-tab-completion/ # Tab completion with FZF preview
│   ├── oh-my-zsh/      # Zsh framework (optional)
│   ├── oh-my-tmux/     # Tmux configuration framework
│   ├── tpm/            # Tmux Plugin Manager
│   └── vimrc/          # Vim configuration
└── motd/               # Message of the day system
    ├── motd.sh         # Main MOTD (hostname routing)
    ├── motd-<host>.sh  # Host-specific MOTDs
    ├── widgets.sh      # Widget system with caching
    ├── widgets/        # Custom widget extensions
    └── systemd/        # Timers for background updates
```

## Components

| Category | Components |
|----------|------------|
| Shell | `bash_prompt`, `zsh_prompt`, `bash_defaults`, `zsh_defaults`, `bash_completion`, `zsh_completion` |
| FZF | `fzf`, `fzf_git`, `fzf_tmux`, `fzf_docker`, `fzf_systemctl`, `fzf_extras` |
| Pickers | `ssh_picker`, `journalctl_picker` |
| Tools | `dot_help`, `dot_doctor`, `helpers`, `navi` |
| System | `platform`, `feature_flags`, `brew` |

## Shell Loading Order

```
bashrc/zshrc
├── config/dotfiles.config (colors, settings)
├── components/platform (OS detection)
├── components/feature_flags (load flags + local overrides)
├── components/*_defaults (shell settings)
├── components/*_prompt (if enabled)
├── components/fzf* (if enabled)
├── alias/* (if enabled)
├── components/helpers (if enabled)
└── components/navi (if enabled)
```

## Key Commands

| Command | Description |
|---------|-------------|
| `dot help` | Command and keybinding overview |
| `dot doctor` | Diagnose common problems |
| `dot alias` | Show aliases with availability status |
| `dot update` | Update dotfiles and reload shell |
| `fh` | FZF history picker |
| `cdf` | FZF directory picker |
| `gco` | Git checkout (branch picker) |
| `gshow` | Git show (commit picker) |
| `ts`/`tw`/`tp` | Tmux session/window/pane picker |
| `sshp` | SSH host picker |
| `dcheat`/`cheat` | Local cheat sheet navigation |

## MOTD Widgets

Built-in widgets in `motd/widgets.sh`:
- **docker** — running/stopped container counts
- **tailscale** — Tailscale IP or status
- **wireguard** — WireGuard IP and allowed IPs
- **proxmox** — LXC/VM counts (running/total)
- **homebrew** — available updates (formulas/casks)
- **network** — host reachability status

## Entry Points

- **Install**: `install.sh` (or curl one-liner in README.md)
- **Update**: `dot update` or manually: `git pull --ff-only && git submodule update --init --recursive --depth 1`
- **Auto-update**: `autoupdate.sh` via `DOTFILES_ENABLE_AUTOUPDATE`

## Key Files

| Purpose | Files |
|---------|-------|
| Config & flags | `components/feature_flags`, `components/platform`, `config/local_dotfiles_settings` |
| Shell entry | `bashrc`, `zshrc`, `bash_profile`, `zprofile` |
| Prompts | `components/bash_prompt`, `components/zsh_prompt` |
| FZF | `components/fzf`, `components/fzf_docker`, `components/fzf_git`, `components/fzf_systemctl`, `components/fzf_tmux`, `components/fzf_extras` |
| Utilities | `components/dot_doctor`, `components/dot_help`, `components/helpers` |
| Pickers | `components/ssh_picker`, `components/journalctl_picker` |
| Tmux | `modules/oh-my-tmux/.tmux.conf.local`, `config/tmux.conf.local` |
| MOTD | `motd/motd.sh`, `motd/widgets.sh`, `motd/widgets/`, `motd/motd-<hostname>.sh` |
| Help data | `config/dot_help.json` |

## Conventions

- **Feature flags**: Add to `components/feature_flags`, override in `config/local_dotfiles_settings`
- **Submodules**: Installed via `git clone --recurse-submodules`; `gitconfig` sets `submodule.recurse=true`
- **Tool installation**: Via module scripts (e.g., `modules/fzf/install`), not distro packages
- **Platform detection**: Use `DOTFILES_OS`, `DOTFILES_DISTRO_ID`, `DOTFILES_WSL`, `DOTFILES_CONTAINER` from `components/platform`
- **Line endings**: LF only (see `.gitattributes`)
- **Component naming**: FZF components use `fzf_` prefix, pickers use `_picker` suffix

## Testing

- Syntax check: `bash -n path/to/file`
- Manual test: `source bashrc` or open new shell

## Editing Guidelines

- Make small, focused edits preserving existing style
- Put user-facing defaults behind feature flags
- New modules need `install` script and `README.md` under `modules/<name>/`
- Use `components/platform` for OS checks, not hardcoded conditions
- Keep `install.sh` idempotent (skip if already installed)
- **Keep README.md in sync**: Update relevant sections when changing features, commands, bindings, or flags

## Implementation Examples

| Task | How |
|------|-----|
| New prompt segment | Edit `components/bash_prompt` and `components/zsh_prompt`, update README |
| New alias set | Create `alias/alias-<name>`, source from `alias/alias` |
| New completion | Add to `bash_completion.d/`, enable via `DOTFILES_ENABLE_BASH_COMPLETION` |
| New FZF integration | Create `components/fzf_<name>`, add `DOTFILES_ENABLE_<NAME>_FZF` flag |
| New picker | Create `components/<name>_picker`, add flag, follow `ssh_picker` template |
| New MOTD widget | Create script in `motd/widgets/`, register in `motd/widgets.sh` |

## Feature Flags

All default to `true` unless noted. Override in `config/local_dotfiles_settings`.

| Flag | Description |
|------|-------------|
| `DOTFILES_ENABLE_PROMPT` | Custom bash/zsh prompt |
| `DOTFILES_ENABLE_BASH_COMPLETION` | Bash completions |
| `DOTFILES_ENABLE_FZF` | FZF integration |
| `DOTFILES_ENABLE_NAVI` | Navi cheatsheet tool |
| `DOTFILES_ENABLE_ALIASES` | Load alias files |
| `DOTFILES_ENABLE_SSH_PICKER` | SSH host picker (Ctrl+S) |
| `DOTFILES_ENABLE_GIT_FZF` | Git FZF integration |
| `DOTFILES_ENABLE_FZF_EXTRAS` | Additional FZF functions |
| `DOTFILES_ENABLE_FZF_HISTORY_BINDINGS` | FZF history search |
| `DOTFILES_ENABLE_FZF_CDF_BINDING` | cd with FZF (Alt+C) |
| `DOTFILES_ENABLE_HELPERS` | Helper functions |
| `DOTFILES_ENABLE_FZF_TAB_COMPLETION` | FZF-based tab completion |
| `DOTFILES_ENABLE_EXTRACT_EXT` | Archive extraction helper |
| `DOTFILES_ENABLE_BREW` | Homebrew integration |
| `DOTFILES_ENABLE_OH_MY_ZSH` | Oh My Zsh (default: false) |
| `DOTFILES_ENABLE_MOTD` | Message of the day (default: false) |
| `DOTFILES_ENABLE_MOTD_AUTO_RUN` | Auto-show MOTD on login (default: false) |
| `DOTFILES_ENABLE_MOTD_WIDGETS` | MOTD widget system |
| `DOTFILES_ENABLE_AUTOUPDATE` | Auto-update dotfiles |
| `DOTFILES_ENABLE_TMUX_AUTOSTART` | Auto-start tmux |
| `DOTFILES_ENABLE_SSH_TMUX_RENAME` | Rename tmux window on SSH |
| `DOTFILES_ENABLE_TMUX_FZF` | Tmux FZF integration |
| `DOTFILES_ENABLE_JOURNALCTL_PICKER` | Journalctl unit picker |
| `DOTFILES_ENABLE_SYSTEMCTL_FZF` | Systemctl FZF integration |
| `DOTFILES_ENABLE_DOT_DOCTOR` | Diagnostics command |
| `DOTFILES_ENABLE_DOCKER_FZF` | Docker FZF integration |
| `DOTFILES_ENABLE_DOT_HELP` | Help system |
| `DOTFILES_ENABLE_DOT_HELP_BINDING` | Help keybinding (F1) |
| `DOTFILES_ENABLE_RELOAD_BINDING` | Reload shell binding |
| `DOTFILES_ENABLE_IOBROKER` | ioBroker integrations |

## Change Checklist

Before committing user-facing changes:

- [ ] Code changes implemented and tested
- [ ] Feature flags added/updated in `components/feature_flags`
- [ ] `config/dot_help.json` updated (if adding commands/bindings)
- [ ] README.md sections updated (features, flags, bindings, etc.)
- [ ] CLAUDE.md updated if new conventions established
