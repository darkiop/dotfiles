# Install checklist

This checklist summarizes the tools needed for the dotfiles to work well.

## Core (required)
- [ ] Shell: bash or zsh
- [ ] git
- [ ] curl
- [ ] Standard userland tools: awk, sed, grep, sort, find, tput, hostname, df, uptime

## Common features (enabled by default)
- [ ] fzf (via submodule `modules/fzf/install`, not system packages)
- [ ] tmux (if DOTFILES_ENABLE_TMUX_AUTOSTART=true)
- [ ] jq (MOTD tasks.json + dot_help JSON)
- [ ] dircolors (Linux) or gdircolors (macOS coreutils)

## Optional features (by flag)
- [ ] navi (DOTFILES_ENABLE_NAVI)
- [ ] fzf-tab-completion submodule (DOTFILES_ENABLE_FZF_TAB_COMPLETION)
- [ ] docker (DOTFILES_ENABLE_DOCKER_FZF)
- [ ] systemctl/journalctl (DOTFILES_ENABLE_SYSTEMCTL_FZF / DOTFILES_ENABLE_JOURNALCTL_PICKER)
- [ ] bat or batcat (cheats previews in helpers)
- [ ] eza or lsd (ls aliases)
- [ ] tree (lt alias fallback on macOS)
- [ ] rg (ripgrep, optional for cheats search + fzf completion)
- [ ] oh-my-zsh submodule (DOTFILES_ENABLE_OH_MY_ZSH)

## macOS (Homebrew suggested)
- [ ] brew
- [ ] git
- [ ] curl
- [ ] jq
- [ ] tmux
- [ ] coreutils (gdircolors, greadlink)
- [ ] reattach-to-user-namespace (tmux clipboard, optional)

Suggested install:

```bash
brew install git curl jq fzf tmux coreutils reattach-to-user-namespace
```

## Debian/Ubuntu installer prerequisites
- [ ] apt + sudo (installer uses apt)

Notes:
- fzf is managed via dotfiles submodule (not distro packages on Linux).
- On macOS, Homebrew is not used by the installer, so install deps manually.
