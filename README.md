# my.dotfiles

Bash + Zsh dotfiles with modular components, submodules (vim/tmux/fzf), and optional per-host feature flags.

## Install

### With menu

```bash
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')"
```

If you don't have `curl` yet:

```bash
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')"
```

### Non-interactive

```bash
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')" '' all
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')" '' all load-bashrc
```

### Clone

```bash
git clone --recurse-submodules --shallow-submodules https://github.com/darkiop/dotfiles ~/dotfiles
bash ~/dotfiles/install.sh
```

## Requirements / supported systems

- Shell: bash or zsh
- Distro: the installer is built around `apt` (Debian/Ubuntu). Other distros/macOS need manual package installation.
- Tools: `git`, `curl` (the installer can install missing dependencies via apt/sudo).

### macOS (Homebrew)

The installer does not use Homebrew; install dependencies manually:

```bash
brew install git curl jq fzf tmux coreutils reattach-to-user-namespace
```

Notes:
- `coreutils` provides `gdircolors` and `greadlink` used by prompts/dot doctor on macOS.
- systemd/journalctl features (MOTD timers, `jctl`, systemctl pickers) are Linux-only.

## What it configures

- Bash: `bashrc`, `bash_profile`, `inputrc`, `dircolors`
- Zsh: `zshrc`, `zprofile`
- Git: `gitconfig` (includes optional `~/.gitconfig.local`)
- Prompt: bash `components/bash_prompt`, zsh `components/zsh_prompt` (Git, SSH, sudo, exit code)
- Completions: bash (bash-completion + `bash_completion.d/*`), zsh (`compinit`)
- FZF: installed via `modules/fzf/install --key-bindings --completion` (never via apt)
- FZF extras: `fh` history picker and `cdf` directory picker (optionally binds keys)
- Helpers: `dcheat`, `cheat`, `helpme` (local cheats + help wrappers)
- dot doctor: `dot doctor` quick diagnostics for common issues
- dot help: `dot help` prints CLI overview of commands and keybindings
- oh-my-zsh (optional, submodule `modules/oh-my-zsh`)
- SSH picker: `sshp` (pick host from `~/.ssh/config` via `fzf`)
- Git + fzf helpers: `gco`, `gshow`, `gaddp`, `gstashp`, `gfixup`, `gcp`
- Navi: `Ctrl+G` widget + cheats in `cheats/`
- Tmux: oh-my-tmux + TPM + `config/tmux.conf.local`
- Tmux fzf picker: `ts`/`tw`/`tp` (sessions/windows/panes via `fzf`)
- MOTD: hostname-based scripts in `motd/` (enable via `DOTFILES_ENABLE_MOTD`, optional auto-run `DOTFILES_ENABLE_MOTD_AUTO_RUN`)

## Feature flags (per host)

`bashrc` sources `components/feature_flags` and reads optional overrides from `~/dotfiles/config/local_dotfiles_settings` (gitignored).
`zshrc` also uses `components/feature_flags`.

Example `~/dotfiles/config/local_dotfiles_settings`:

```bash
DOTFILES_ENABLE_AUTOUPDATE=false
DOTFILES_ENABLE_TMUX_AUTOSTART=false
DOTFILES_ENABLE_SSH_TMUX_RENAME=false
```

Available flags:

- `DOTFILES_ENABLE_PROMPT`
- `DOTFILES_ENABLE_BASH_COMPLETION`
- `DOTFILES_ENABLE_FZF`
- `DOTFILES_ENABLE_NAVI`
- `DOTFILES_ENABLE_ALIASES`
- `DOTFILES_ENABLE_SSH_PICKER`
- `DOTFILES_ENABLE_GIT_FZF`
- `DOTFILES_ENABLE_FZF_EXTRAS`
- `DOTFILES_ENABLE_FZF_HISTORY_BINDINGS`
- `DOTFILES_ENABLE_FZF_CDF_BINDING`
- `DOTFILES_ENABLE_HELPERS`
- `DOTFILES_ENABLE_FZF_TAB_COMPLETION`
- `DOTFILES_ENABLE_EXTRACT_EXT`
- `DOTFILES_ENABLE_BREW`
- `DOTFILES_ENABLE_OH_MY_ZSH`
- `DOTFILES_ENABLE_MOTD`
- `DOTFILES_ENABLE_MOTD_AUTO_RUN`
- `DOTFILES_ENABLE_AUTOUPDATE`
- `DOTFILES_ENABLE_TMUX_AUTOSTART`
- `DOTFILES_ENABLE_SSH_TMUX_RENAME`
- `DOTFILES_ENABLE_TMUX_FZF`
- `DOTFILES_ENABLE_JOURNALCTL_PICKER`
- `DOTFILES_ENABLE_DOT_DOCTOR`
- `DOTFILES_ENABLE_DOT_HELP`
- `DOTFILES_ENABLE_DOT_HELP_BINDING` (default `true`)
- `DOTFILES_ENABLE_RELOAD_BINDING` (default `true`)
- `DOTFILES_ENABLE_DOCKER_FZF`
- `DOTFILES_ENABLE_IOBROKER`

## MOTD (hostname-basiert)

- Flags: `DOTFILES_ENABLE_MOTD` (aktiviert Komponenten) und optional `DOTFILES_ENABLE_MOTD_AUTO_RUN` (sourced bei Login). Default: beide `false`.
- Einstieg: `motd/motd.sh` (Alias `motd` wird nur gesetzt, wenn MOTD-Flag an ist). Zieht Farben/Settings aus `config/dotfiles.config`.
- Inhalte: Uptime, Root-/Home-Speicher (`/home` bevorzugt via Cache `/usr/local/share/dotfiles/dir-sizes`), IP/OS/Load, Tasks aus `motd/tasks.json` (via `jq`), optionale APT-Updates (Cache-Dateien unter `/usr/local/share/dotfiles/apt-updates-*`, gesteuert via `MOTD_SHOW_APT_UPDATES` in `config/dotfiles.config`).
- macOS: OS-Name via `sw_vers`, IP via `ipconfig`/`ifconfig`, Load via `sysctl -n vm.loadavg`, Home-Fallback `/Users`.
- Host-Hooks: optionales Proxmox-Snippet `motd/motd-proxmox.sh` (auto bei `pveversion`).
- Timer/Caches: `motd/systemd/update-motd-apt-infos.{service,timer}` schreibt APT-Caches; `motd/systemd/calc-dir-size-homes.{service,timer}` schreibt `dir-sizes`.
  - Installer: Beim Full-Install (`bash ~/dotfiles/install.sh` → `Install dotfiles (all)` oder non-interactive `all`) werden die Timer auf systemd-Systemen automatisch installiert (Menüpunkt `Install MOTD systemd timers` ist zum Neuinstallieren).
  - Manuell: `sudo cp ~/dotfiles/motd/systemd/*.service ~/dotfiles/motd/systemd/*.timer /etc/systemd/system/ && sudo systemctl daemon-reload`
  - Enable: `sudo systemctl enable --now update-motd-apt-infos.timer calc-dir-size-homes.timer`
  - Manual run: `sudo systemctl start update-motd-apt-infos.service calc-dir-size-homes.service`
  - Check: `systemctl list-timers | rg '(update-motd-apt-infos|calc-dir-size-homes)'`

## Prompt erklärt (bash + zsh)

Aktiviert via `DOTFILES_ENABLE_PROMPT` (default `true`).

Der Prompt ist **zweizeilig** und sieht schematisch so aus:

- Zeile 1: `┌[TIME] [ssh:USER@HOST (IP): CWD (PERMS)] [git:…] [sudo]`
- Zeile 2: `└─$` (bei root rot)

Zusätzlich gilt: Wenn der letzte Befehl mit Exit-Code `!= 0` endet, werden die Linienzeichen (`┌`/`└─`) **rot** (sonst blau).

### Bash Prompt (`components/bash_prompt`)

Der Prompt wird in `BUILD_PROMPT()` gebaut und per `PROMPT_COMMAND` nach jedem Kommando aktualisiert.

- `┌` / `└─`: Farbe hängt vom Exit-Code des letzten Befehls ab (0 → blau, sonst rot).
- `[TIME]`: `\t` (HH:MM:SS), grün, in eckigen Klammern.
- `[ssh:…]`: erscheint nur, wenn eine SSH-Session erkannt wird (`SSH_CONNECTION` oder `SSH_CLIENT`).
- `USER🤘HOST`: `\u` + Separator + `\h` (User/Host). Separator ist `🤘` (root: `💀`), User hellblau (root rot), Host blau.
- `(IP)`: eine IPv4-Adresse (nur wenn gefunden). Ermittelt einmal beim Laden von `components/bash_prompt`:
  - Linux: `ip -4 a` (Fallback: `hostname -I`)
  - macOS: `ipconfig getifaddr` (Fallback: `ifconfig`)
  - Filter: kein `127.*`, kein `169.254.*`, kein `172.*`, kein `100.*`.
- `CWD`: `\w` (aktuelles Verzeichnis), orange.
- `(PERMS)`: Rechte des aktuellen Verzeichnisses (Linux: `stat -c %a .`, macOS: `stat -f %Lp .`).
- `[git:…]`: erscheint nur innerhalb eines Git-Repos und nur wenn `__git_ps1` verfügbar ist.
  - Basis kommt aus `__git_ps1` (mit `GIT_PS1_SHOWDIRTYSTATE`, `…STASHSTATE`, `…UNTRACKEDFILES`, `…UPSTREAM=auto`).
  - Typische Marker am Branch: `+` (staged), `*` (dirty), `$` (stash), `%` (untracked).
  - Upstream-Marker am Ende: `=` (gleich), `>` (ahead), `<` (behind), `<>` (diverged) — dieser Marker wird extra **rot** gefärbt.
- `[sudo]`: erscheint nur, wenn `sudo -vn` ohne Passwort klappt (sudo-Ticket aktiv) und du nicht root bist.
- Terminal-“Garbage” beim Login: Es gibt einen einmaligen “stdin flush”, der unerwartete Terminal-Antworten (z.B. OSC 11) schluckt; in tmux wird dafür kurz gewartet, um verzögerte Antworten abzufangen.

### Zsh Prompt (`components/zsh_prompt`)

Der Prompt wird in `dotfiles_prompt_precmd()` gebaut (Hook via `precmd`) und verwendet zsh-native Prompt-Escapes.

- Zeilenaufbau: gleiches Layout wie in bash, nur mit `%n` (User), `%m` (Host), `%~` (Pfad mit `~`) und `%D{%H:%M:%S}` (Zeit).
- Linienzeichen: können via `DOTFILES_PROMPT_LEAD` und `DOTFILES_PROMPT_TAIL` überschrieben werden (standard: `┌` und `└─`).
- User/Host-Separator: `🤘` (root: `💀`).
- `(IP)`: bevorzugt bei SSH die Server-IP aus `SSH_CONNECTION`, sonst wird eine IPv4 gesucht:
  - Linux: `ip -4 a` (Fallback: `hostname -I`)
  - macOS: `ipconfig getifaddr` (Fallback: `ifconfig`)
  - Filter: kein `127.*`, kein `169.254.*`, kein `172.*`, kein `100.*`.
- `[git:…]`: wird ohne `__git_ps1` berechnet:
  - Branch/Ref: Branchname (oder Tag, oder short SHA).
  - Flags: `+` (staged), `*` (dirty), `$` (stash), `%` (untracked).
  - Upstream: `=` / `>` / `<` / `<>` wie oben (über `git rev-list --left-right --count HEAD...@{u}`).
  - Farben: `git:` Label gelb, Branch grün, Flags/Upstream rot.
  - Wichtig: `%` hat in zsh-Prompts Spezialbedeutung, deshalb werden `%` in Branch/Flags intern escaped.
- `[sudo]`: analog zu bash (sudo-Ticket aktiv).
- Terminal-“Garbage” beim Login: analoger einmaliger “stdin flush” (inkl. kurzer Wartezeit in tmux).

## Git + fzf helpers

Enabled by default via `DOTFILES_ENABLE_GIT_FZF` (disable per host via `~/dotfiles/config/local_dotfiles_settings`).

- `gco`: pick a branch/tag and `git checkout`
- `gshow`: pick a commit and `git show`
- `gaddp`: pick modified files and `git add`
- `gstashp show|apply|pop|drop`: pick a stash and run the action
- `gfixup`: pick a commit and create a `git commit --fixup`
- `gcp`: pick a commit hash and copy it (uses `wl-copy`/`xclip`/`pbcopy` if available)

## Tmux fzf picker

Enabled by default via `DOTFILES_ENABLE_TMUX_FZF`.

- `ts`: pick a session and switch client
- `tw`: pick a window across sessions and focus it
- `tp`: pick a pane across sessions and focus it
- Keybinding: `Ctrl+F` triggers `tw` (only inside tmux; overrides the default forward-char binding)

## journalctl picker

Enabled by default via `DOTFILES_ENABLE_JOURNALCTL_PICKER`.

- `jctl`: pick a systemd service unit via `fzf` and view the last 500 log lines
- `jctl follow`: same, but follows the log (`journalctl -f`)

## Docker fzf helpers

Enabled by default via `DOTFILES_ENABLE_DOCKER_FZF`.

Commands:

- `dps`: pick a container via `fzf` and show its `docker ps` line
- `dexec [cmd...]`: pick a container and `docker exec -it` into it
  - default command: `bash --login` (fallback: `sh`)
  - example: `dexec env` or `dexec bash`
- `dlogs [follow]`: pick a container and show logs
  - `dlogs`: last ~500 lines (or full logs in `lnav`)
  - `dlogs follow`: follow logs (`docker logs -f`)

How it works:

- Container list: `docker ps -a` is formatted into a picker list (ID, name, image, status, ports).
- Preview: shows the last ~50 log lines for the currently highlighted container.
- Permissions: if `docker ps` is not readable for the current user, the helper auto-falls back to `sudo docker` (so you may see a sudo password prompt).
- Compatibility: if you already have `dps`/`dexec`/`dlogs` as aliases (e.g. from `alias/alias-docker`), the functions override them when this feature is enabled.

Disable per host:

```bash
DOTFILES_ENABLE_DOCKER_FZF=false
```

## dot doctor

Enabled by default via `DOTFILES_ENABLE_DOT_DOCTOR`.

- `dot doctor`: quick diagnostics for common dotfiles issues.

What it checks (high level):

- Git repo: whether `~/dotfiles` exists and is a git repo
- Git status: current branch + whether the repo is clean/dirty
- Submodules: whether submodules are initialized/up-to-date
- Symlinks: whether common links like `~/.bashrc`, `~/.zshrc`, `~/.tmux.conf`, `~/.tmux.conf.local` point to `~/dotfiles/*`
- Required tools: checks common binaries, and more depending on enabled flags (e.g. `fzf`, `jq`, `journalctl`, `lnav`, `tmux`)
- MOTD timers: on systemd systems prints `is-enabled` state for `update-motd-apt-infos.timer` and `calc-dir-size-homes.timer`

Interpreting the output:

- `OK`: check passed
- `WARN`: something is unusual but dotfiles might still work; usually includes a hint what to fix
- `FAIL`: required piece is missing (e.g. not a git repo)
- `INFO`: informational rows (e.g. enabled timers, selected feature flags)

Examples:

```bash
dot doctor
```

Disable per host:

```bash
DOTFILES_ENABLE_DOT_DOCTOR=false
```

## dot help

Enabled by default via `DOTFILES_ENABLE_DOT_HELP`.

- `dot help`: prints a CLI overview of enabled dotfiles commands and keybindings
- `dot`: same as `dot help`
- Requires: `jq` (reads JSON metadata)
- Data source: `~/dotfiles/config/dot_help.json` (optional override via `DOTFILES_DOT_HELP_JSON`)

Optional keybindings (bash + zsh):

- `DOTFILES_ENABLE_DOT_HELP_BINDING`: binds `Ctrl+H` to open `dot help`
- `DOTFILES_ENABLE_RELOAD_BINDING`: binds `Alt+R` to run `dot reload`

Commands:

- `dot reload`: clears the screen and reloads your current shell rc file
  - Bash: `~/.bashrc` (fallback: `~/dotfiles/bashrc`)
  - Zsh: `~/.zshrc` (fallback: `~/dotfiles/zshrc`)

Disable per host:

```bash
DOTFILES_ENABLE_DOT_HELP=false
```

## FZF extras

Enabled by default via `DOTFILES_ENABLE_FZF_EXTRAS`.

- `fh`: pick a command from history via `fzf`
- `cdf`: pick a directory via `fzf` and `cd` into it
- `DOTFILES_ENABLE_FZF_HISTORY_BINDINGS`: when enabled, binds `Ctrl+R` to the `fh` picker (bash + zsh)
- `DOTFILES_ENABLE_FZF_CDF_BINDING`: when enabled, binds `Alt+C` to the `cdf` picker (bash + zsh)

## oh-my-zsh (optional)

Enabled via `DOTFILES_ENABLE_OH_MY_ZSH` (default `false`).

- Loads `modules/oh-my-zsh/oh-my-zsh.sh` if the submodule is present (`git submodule update --init --recursive modules/oh-my-zsh`)
- Disables oh-my-zsh auto-update and compfix to avoid prompts
- Uses empty `plugins=()` by default; customize in your own zsh local config if needed

## FZF tab completion

Enabled by default via `DOTFILES_ENABLE_FZF_TAB_COMPLETION`.

- Bash: binds `TAB` to `fzf-tab-completion` (`modules/fzf-tab-completion/bash/fzf-bash-completion.sh`)
- Zsh: binds `TAB` to `fzf-tab-completion` (`modules/fzf-tab-completion/zsh/fzf-zsh-completion.sh`)
- Robustness: command paths for the completion scripts are sanitized (prefers `gawk/gsed/rg`, falls back to `awk/sed/egrep`).

## Helpers

Enabled by default via `DOTFILES_ENABLE_HELPERS`.

- `dcheat [query]`: pick a local cheat file from `~/dotfiles/cheats/*.cheat` via `fzf` and view it (preview uses `bat` if available, otherwise `sed`)
- `cheat <topic>`: prefer local cheats; if none match, fallback to `cheat.sh/<topic>` (needs `curl`), then `tldr <topic>` (if installed)
- `helpme <command>`: show the best available help (local cheat if present, otherwise `<command> --help`, fallback to `man <command>`)

Optional:
- Set `DOTFILES_CHEATS_DIR` to use a different cheats directory than `~/dotfiles/cheats`.

## extract() Erweiterung

Enabled by default via `DOTFILES_ENABLE_EXTRACT_EXT`.

- Adds extra formats to `extract <file>`: `*.7z` (7z), `*.xz` (unxz/xz -d), `*.zst`/`*.zstd` (unzstd/zstd -d)
- Existing formats remain (tar.gz/tbz2/zip/rar/etc.)
- Each format checks whether the required tool is installed and prints a helpful error if missing.

## Platform detection

`bashrc` sources `components/platform`, which exports:

- `DOTFILES_OS` (`linux`, `darwin`, `unknown`)
- `DOTFILES_DISTRO_ID`, `DOTFILES_DISTRO_LIKE` (from `/etc/os-release`)
- `DOTFILES_WSL` (0/1)
- `DOTFILES_CONTAINER` (0/1)

## Updating

- Manual: `cd ~/dotfiles && git pull --ff-only && git submodule update --init --recursive --depth 1`
- Automatic: `autoupdate.sh` runs from `.bashrc` after ~20 logins (disable via `DOTFILES_ENABLE_AUTOUPDATE=false`).

## Notes / troubleshooting

- Line endings: `.gitattributes` enforces LF for shell files to avoid Bash errors like `syntax error near unexpected token $'in\\r'`.
- Submodules: `gitconfig` enables `submodule.recurse=true`; if you have SSH-only access or no key, submodule fetch can fail. `autoupdate.sh` disables submodule recursion for its pull.
- Credentials: add sensitive Git settings (e.g. credential helper, signing keys) to `~/.gitconfig.local`.

## LINKS

### Inspired by other dotfile projects

- [github.com/1995parham/dotfiles](https://github.com/1995parham/dotfiles)
- [github.com/denisidoro/dotfiles](https://github.com/denisidoro/dotfiles)

### Projects used by my dotfiles

- [github.com/koljah-de/simple-bash-prompt](https://github.com/koljah-de/simple-bash-prompt)
- [github.com/chubin/cheat.sh](https://github.com/chubin/cheat.sh)
- [github.com/denisidoro/navi](https://github.com/denisidoro/navi)
- [github.com/Peltoche/lsd](https://github.com/Peltoche/lsd)
- [github.com/sharkdp/bat](https://github.com/sharkdp/bat)
- [github.com/amix/vimrc](https://github.com/amix/vimrc)
- [github.com/mdom/dategrep](https://github.com/mdom/dategrep)
- [lnav.org](http://lnav.org)
- [github.com/gpakosz/.tmux](https://github.com/gpakosz/.tmux)

### misc

- [dotfiles.github.io/tutorials/](https://dotfiles.github.io/tutorials/)
- [github.com/vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)
- [github.com/vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
- [github.com/starship/starship](https://github.com/starship/starship)
- [github.com/ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
- [github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack#quick-installation](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack#quick-installation)
- [github.com/ranger/ranger](https://github.com/ranger/ranger)
- [github.com/brantb/solarized](https://github.com/brantb/solarized)
- [github.com/Bash-it/bash-it](https://github.com/Bash-it/bash-it)
- [github.com/tmux](https://github.com/tmux)
- [github.com/seebi/dircolors-solarized](https://github.com/seebi/dircolors-solarized)
- [github.com/clvv/fasd](https://github.com/clvv/fasd)
- [github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [github.com/LeCoupa/awesome-cheatsheets/blob/master/languages/bash.sh](https://github.com/LeCoupa/awesome-cheatsheets/blob/master/languages/bash.sh)
- [github.com/aristocratos/bashtop](https://github.com/aristocratos/bashtop)
- [github.com/reujab/silver](https://github.com/reujab/silver)
- [github.com/existme/notes](https://github.com/existme/notes)
- [drasite.com/blog/Pimp%20my%20terminal#top-from-the-future](https://drasite.com/blog/Pimp%20my%20terminal#top-from-the-future)
- [ichi.pro/de/das-essential-bash-spickzettel-15514461037920](https://ichi.pro/de/das-essential-bash-spickzettel-15514461037920)
- [wiki.ubuntuusers.de/Bash/Prompt](https://wiki.ubuntuusers.de/Bash/Prompt)
- [www.linux.com/learn/enhancing-virtual-terminals-byobu](https://www.linux.com/learn/enhancing-virtual-terminals-byobu)
- [www.cheatsheet.wtf/bash/](https://www.cheatsheet.wtf/bash/)
- [shellmagic.xyz](https://shellmagic.xyz)
- [github.com/jlevy/the-art-of-command-line/blob/master/README-de.md](https://github.com/jlevy/the-art-of-command-line/blob/master/README-de.md)

## Keyboard-Bindings

Some bindings below are enabled via feature flags (e.g. `DOTFILES_ENABLE_FZF_HISTORY_BINDINGS`, `DOTFILES_ENABLE_FZF_CDF_BINDING`, `DOTFILES_ENABLE_DOT_HELP_BINDING`, `DOTFILES_ENABLE_RELOAD_BINDING`).

### Bash

| Key                                      | Function                        |
| :--------------------------------------- | :------------------------------ |
| <kbd>CTRL</kbd> + <kbd>A</kbd>           | jump to the beginning of a line |
| <kbd>CTRL</kbd> + <kbd>E</kbd>           | jump to the end of the line     |
| <kbd>CTRL</kbd> + <kbd>R</kbd>           | `fh` history picker (or reverse-search) |
| <kbd>CTRL</kbd> + <kbd>C</kbd>           | interrupt command               |
| <kbd>CTRL</kbd> + <kbd>L</kbd>           | clear screen                    |
| <kbd>TAB</kbd>                           | fzf tab-completion (optional)   |
| <kbd>CTRL</kbd> + <kbd>F</kbd>           | tmux window picker `tw` (inside tmux) |
| <kbd>CTRL</kbd> + <kbd>H</kbd>           | open `dot help` (optional)      |
| <kbd>ALT</kbd> + <kbd>C</kbd>            | `cdf` directory picker          |
| <kbd>ALT</kbd> + <kbd>R</kbd>            | reload shell rc (`dot reload`)  |
| <kbd>ALTGR</kbd> + <kbd>Mousewheel</kbd> | bash history                    |

### Zsh

| Key                           | Function               |
| :---------------------------- | :--------------------- |
| <kbd>CTRL</kbd> + <kbd>R</kbd> | `fh` history picker (or reverse-search) |
| <kbd>TAB</kbd>                  | fzf tab-completion (optional)          |
| <kbd>CTRL</kbd> + <kbd>F</kbd>  | tmux window picker `tw` (inside tmux) |
| <kbd>CTRL</kbd> + <kbd>H</kbd>  | open `dot help` (optional)            |
| <kbd>ALT</kbd> + <kbd>C</kbd>  | `cdf` directory picker |
| <kbd>ALT</kbd> + <kbd>R</kbd>  | reload shell rc (`dot reload`)        |

### Navi

| Key                            | Function       |
| :----------------------------- | :------------- |
| <kbd>CTRL</kbd> + <kbd>G</kbd> | show navi menu |

### tmux

PREFIX is <kbd>CTRL</kbd> + <kbd>a</kbd>

| Key                                                | Function                                   |
| :------------------------------------------------- | :----------------------------------------- |
| <kbd>ALT</kbd> + <kbd>LEFT</kbd>                   | switch to the left pane                    |
| <kbd>ALT</kbd> + <kbd>RIGHT</kbd>                  | switch to the right pane                   |
| <kbd>ALT</kbd> + <kbd>UP</kbd>                     | switch to the upper pane                   |
| <kbd>ALT</kbd> + <kbd>DOWN</kbd>                   | switch to the lower pane                   |
| <kbd>CTRL</kbd> + <kbd>t</kbd>                     | create a new window (no prefix)            |
| <kbd>F11</kbd>                                     | pane > fullscreen                          |
| <kbd>SHIFT</kbd> + <kbd>LEFT</kbd>                 | switch to left window                      |
| <kbd>SHIFT</kbd> + <kbd>RIGHT</kbd>                | switch to right window                     |
| <kbd>PREFIX</kbd> + <kbd><</kbd>                   | Split the screen vertically                |
| <kbd>PREFIX</kbd> + <kbd>-</kbd>                   | Split the screen horizontally              |
| <kbd>PREFIX</kbd> + <kbd>c</kbd>                   | create a new window                        |
| <kbd>PREFIX</kbd> + <kbd>t</kbd>                   | create a new window                        |
| <kbd>PREFIX</kbd> + <kbd>w</kbd>                   | close the window                           |
| <kbd>PREFIX</kbd> + <kbd>s</kbd>                   | show windows                               |
| <kbd>PREFIX</kbd> + <kbd>,</kbd>                   | rename window                              |
| <kbd>PREFIX</kbd> + <kbd>d</kbd>                   | detach session                             |
| <kbd>PREFIX</kbd> + <kbd>e</kbd>                   | open tmux.conf.local                       |
| <kbd>PREFIX</kbd> + <kbd>TAB</kbd>                 | switch between last and current window     |
| <kbd>PREFIX</kbd> + <kbd>z</kbd>                   | pane > fullscreen                          |
| <kbd>PREFIX</kbd> + <kbd>r</kbd>                   | reload tmux.conf                           |
| <kbd>PREFIX</kbd> + <kbd>?</kbd>                   | list shortcuts                             |
| <kbd>PREFIX</kbd> + <kbd>CTRL</kbd> + <kbd>s</kbd> | save tmux environment to ~/.tmux/resurrect |
| <kbd>PREFIX</kbd> + <kbd>CTRL</kbd> + <kbd>r</kbd> | restore tmux environment                   |
| <kbd>PREFIX</kbd> + <kbd>$</kbd>                   | rename session                             |
