# Install Checklist

Everything you need to get the dotfiles running on Debian/Ubuntu or macOS.

## Quick Start

**Debian/Ubuntu:**
```bash
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')"
```

**macOS:**
```bash
# Install Homebrew first if needed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then run the dotfiles installer
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')"
```

## Dependencies Overview

The installer handles most dependencies automatically. Here's what gets installed:

### Core Requirements

These are needed for the installer to run:

| Tool | Debian/Ubuntu | macOS | Notes |
|------|---------------|-------|-------|
| bash | Pre-installed | Pre-installed | Required for installer |
| git | Auto-installed | Auto-installed | Clones the repo |
| curl | Auto-installed | Pre-installed | Downloads installer |
| sudo | Auto-installed | Pre-installed | Needed for apt |

### Shell Dependencies

| Tool | Debian/Ubuntu | macOS | Purpose |
|------|---------------|-------|---------|
| bash | Pre-installed | Pre-installed | Primary shell |
| zsh | Auto-installed | Pre-installed | Alternative shell |

### Feature Dependencies

These are installed by `install.sh` option "Install dependencies":

| Tool | Debian/Ubuntu | macOS (brew) | Purpose |
|------|---------------|--------------|---------|
| jq | `jq` | `jq` | MOTD tasks, dot help JSON parsing |
| tmux | `tmux` | `tmux` | Terminal multiplexer |
| vim | `vim` | `vim` | Text editor (vimrc config) |
| bat | `bat` (cmd: `batcat`) | `bat` | Syntax highlighting for previews |
| lsd | `lsd` | `lsd` | Modern ls replacement |
| fzf | Via submodule | Via submodule | Fuzzy finder (not from apt/brew) |

### macOS-Specific Dependencies

| Tool | Package | Purpose |
|------|---------|---------|
| gdircolors | `coreutils` | Color support for ls |
| greadlink | `coreutils` | GNU readlink for scripts |
| gawk | `gawk` | fzf-tab-completion compatibility |
| reattach-to-user-namespace | `reattach-to-user-namespace` | tmux clipboard integration |

## Manual Installation

If you prefer to install dependencies yourself:

**Debian/Ubuntu:**
```bash
sudo apt update
sudo apt install -y git curl sudo jq tmux vim bat lsd zsh
```

**macOS (Homebrew):**
```bash
brew install git jq tmux vim bat lsd coreutils gawk reattach-to-user-namespace
```

## Optional Tools

These aren't installed automatically but enhance specific features:

| Tool | Feature Flag | Purpose |
|------|--------------|---------|
| navi | `DOTFILES_ENABLE_NAVI` | Cheatsheet browser |
| docker | `DOTFILES_ENABLE_DOCKER_FZF` | Container management helpers |
| systemctl | `DOTFILES_ENABLE_SYSTEMCTL_FZF` | Service management (Linux only) |
| journalctl | `DOTFILES_ENABLE_JOURNALCTL_PICKER` | Log viewing (Linux only) |
| ripgrep (rg) | — | Faster search in cheats and fzf |
| eza | — | Modern ls replacement (alternative to lsd) |
| tree | — | Directory tree display |
| lnav | — | Log file viewer for jctl/lctl |

## Submodules

The dotfiles include these as git submodules (managed automatically):

| Submodule | Path | Purpose |
|-----------|------|---------|
| fzf | `modules/fzf` | Fuzzy finder (preferred over system packages) |
| oh-my-tmux | `modules/oh-my-tmux` | Tmux configuration framework |
| tpm | `modules/tpm` | Tmux Plugin Manager |
| vimrc | `modules/vimrc` | Vim configuration (amix/vimrc) |
| fzf-tab-completion | `modules/fzf-tab-completion` | Tab completion with fzf |
| oh-my-zsh | `modules/oh-my-zsh` | Zsh framework (optional) |

## Platform-Specific Notes

### Debian/Ubuntu

- The installer uses `apt` for package management
- `bat` is available as `batcat` (Debian/Ubuntu naming conflict)
- systemd features (MOTD timers, systemctl/journalctl pickers) work out of the box
- fzf is installed from the submodule, not from apt (ensures latest version)

### macOS

- Homebrew is required for dependency installation
- The installer detects macOS and uses `brew install` instead of `apt`
- systemd features (MOTD timers, `jctl`, `sctl`) are not available
- Use `lctl` for viewing launchd/Homebrew service logs instead
- Some tools have different names: `gdircolors` instead of `dircolors`

## Verification

After installation, run diagnostics:

```bash
dot doctor
```

This checks:
- Git repo status and submodules
- Symlinks for shell configs
- Required binaries
- Feature flag status
- MOTD timer status (Linux)

## Troubleshooting

**"command not found: dot"**
- Reload your shell: `exec bash` or `exec zsh`
- Or source manually: `source ~/.bashrc`

**Submodules not initialized**
```bash
cd ~/dotfiles
git submodule update --init --recursive --depth 1
```

**fzf not working**
- Don't install fzf via apt/brew, use the submodule installer:
```bash
~/dotfiles/modules/fzf/install --key-bindings --completion --no-update-rc
```

**bat command not found (Debian/Ubuntu)**
- The command is `batcat`, not `bat`. An alias is set up automatically.

**macOS: gdircolors not found**
```bash
brew install coreutils
```
