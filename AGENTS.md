## Overview

This repository contains personal shell dotfiles (bash/zsh) organized as modular components and submodules. Key goals for changes: be minimal, POSIX-friendly where reasonable, and preserve per-host feature flags.

## Repository structure

```
dotfiles/
├── alias/              # Alias sets (alias, alias-docker, alias-git, etc.)
├── bash_completion.d/  # Custom bash completions
├── bin/                # Custom scripts
├── cheats/             # Usage examples and keybindings documentation
├── components/         # Shell components (prompt, fzf, helpers, etc.)
├── config/             # Configuration files (dot_help.json, tmux.conf.local, etc.)
├── modules/            # Git submodules (fzf, oh-my-tmux, oh-my-zsh, vimrc, tpm)
└── motd/               # Message of the day scripts and widgets
    ├── widgets/        # Individual widget scripts
    └── systemd/        # Systemd units for MOTD updates
```

## Quick entrypoints

- Installer: `install.sh` (also runnable via the curl/wget one-liner in [README.md](README.md)).
- Update: `cd ~/dotfiles && git pull --ff-only && git submodule update --init --recursive --depth 1` (see README.md "Updating").
- Autoupdate: `autoupdate.sh` controlled by `DOTFILES_ENABLE_AUTOUPDATE` in `config/local_dotfiles_settings`.

## Important files & places to change

- Configuration & flags: `components/feature_flags`, `components/platform`, and `config/local_dotfiles_settings` (gitignored) for host overrides.
- Shell entrypoints: `bashrc`, `zshrc`, `bash_profile`, `zprofile`.
- Prompt components: `components/bash_prompt` (bash) and `components/zsh_prompt` (zsh).
- FZF integrations: `components/fzf`, `components/fzf_docker`, `components/fzf_git`, `components/fzf_systemctl`, `components/fzf_tmux`, `components/fzf_extras`.
- Helper utilities: `components/dot_doctor` (diagnostics), `components/dot_help` (help system), `components/helpers` (utility functions).
- Pickers: `components/ssh_picker`, `components/journalctl_picker`.
- Modules: `modules/<name>/` — add an `install` script and `README.md` when adding new modules (see `modules/fzf`).
- tmux: `modules/oh-my-tmux/.tmux.conf.local` and `config/tmux.conf.local` for local overrides.
- MOTD: `motd/motd.sh` (main), `motd/widgets.sh` (widget system), `motd/widgets/` (individual widgets), and host-specific scripts (`motd/motd-<hostname>.sh`).
- Cheats and docs: `cheats/` contains many usage examples and keybindings.
- dot help data: `config/dot_help.json` stores descriptions for `dot help` (keep it in sync when adding/removing commands or keybindings).

## Conventions and patterns

- Per-host feature flags: prefer adding switches to `components/feature_flags` and expose toggles in `config/local_dotfiles_settings` rather than editing `bashrc` directly.
- Submodules: repo expects submodules for vim/tmux/fzf/oh-my-zsh/tpm; `git clone --recurse-submodules` is the default install path. `gitconfig` sets `submodule.recurse=true`.
- Packaging: fzf and other tools are installed via module scripts (e.g., `modules/fzf/install --key-bindings --completion`) not distro packages.
- Platform detection: `components/platform` exports `DOTFILES_OS`, `DOTFILES_DISTRO_ID`, `DOTFILES_WSL`, and `DOTFILES_CONTAINER`. Use these variables for conditional logic.
- Line endings: keep LF (see `.gitattributes`). Avoid CRLF in shell files.
- MOTD widgets: widgets are standalone scripts in `motd/widgets/` that output one line. Enable via `DOTFILES_ENABLE_MOTD_WIDGETS`. Host-specific logic goes in `motd/motd-<hostname>.sh`.
- Component naming: FZF-related components use `fzf_` prefix (e.g., `fzf_docker`, `fzf_systemctl`). Pickers use `_picker` suffix (e.g., `ssh_picker`, `journalctl_picker`).

## Testing & validation

- Syntax-check shell changes with: `bash -n path/to/file` before committing.
- Quick manual test: source the relevant file (`source bashrc` or open a new shell) and verify prompt/completions.

## Editing guidance for AI agents

- Make small, focused edits. Preserve existing style and comments. Modifications that change user-facing defaults should be placed behind feature flags in `components/feature_flags`.
- When adding a new module, include an `install` script and `README.md` under `modules/<name>/` and document any prerequisites in the root `README.md`.
- Prefer runtime checks using `components/platform` rather than hardcoding OS checks.
- For updates affecting install flow, update `install.sh` and include idempotent checks (e.g., skip when already installed).
- **Keep README.md in sync**: When adding/removing features, commands, bindings, or flags, update the corresponding sections in `README.md`:
  - New commands → update "What it configures" section
  - New flags → update "Feature flags (per host)" list
  - New bindings → update "Keyboard-Bindings" tables
  - Prompt changes → update "Prompt erklärt" section
  - MOTD changes → update "MOTD (hostname-basiert)" section
  - dot help changes → update "dot help" section

## Examples (where to implement common changes)

- Add new prompt segments: edit `components/bash_prompt` and `components/zsh_prompt`. Then update README.md "Prompt erklärt" section.
- Add an alias set: create `alias/alias-<name>` and source it from `alias/alias`. Document in README.md if user-facing.
- Add a completion: put script into `bash_completion.d/` and enable via `DOTFILES_ENABLE_BASH_COMPLETION`.
- Add an FZF integration: create `components/fzf_<name>`, add a feature flag `DOTFILES_ENABLE_<NAME>_FZF`, and source it conditionally from `bashrc`/`zshrc`.
- Add a picker: create `components/<name>_picker`, add a feature flag, define keybindings and functions. Follow `ssh_picker` or `journalctl_picker` as templates.
- Add a MOTD widget: create a script in `motd/widgets/` that outputs a single line. Register it in `motd/widgets.sh`.
- After implementing any change: verify that relevant sections in README.md reflect new behavior.

## Current feature flags

All flags default to `true` unless noted. Override in `config/local_dotfiles_settings`.

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

## Change checklist (for significant changes)

Before committing changes that affect user-facing features:

- [ ] Code changes implemented and tested
- [ ] Feature flags added/updated in `components/feature_flags`
- [ ] `config/dot_help.json` updated (if adding commands/bindings)
- [ ] README.md updated:
  - [ ] "What it configures" section
  - [ ] Feature flags list
  - [ ] Keyboard-Bindings tables
  - [ ] Relevant detailed sections (Prompt/MOTD/dot help/etc.)
- [ ] CLAUDE.md updated if new conventions were established

If anything here is unclear or you want me to expand examples, tell me which area to iterate on.
