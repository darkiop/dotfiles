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
- Distro: the installer is built around `apt` (Debian/Ubuntu). Other distros need manual package installation.
- Tools: `git`, `curl` (the installer can install missing dependencies via apt/sudo).

## What it configures

- Bash: `bashrc`, `bash_profile`, `inputrc`, `dircolors`
- Zsh: `zshrc`, `zprofile`
- Git: `gitconfig` (includes optional `~/.gitconfig.local`)
- Prompt: bash `components/bash_prompt`, zsh `components/zsh_prompt` (Git, SSH, sudo, exit code)
- Completions: bash (bash-completion + `bash_completion.d/*`), zsh (`compinit`)
- FZF: installed via `modules/fzf/install --key-bindings --completion` (never via apt)
- FZF extras: `fh` history picker and `cdf` directory picker (optionally binds keys)
- SSH picker: `sshp` (pick host from `~/.ssh/config` via `fzf`)
- Git + fzf helpers: `gco`, `gshow`, `gaddp`, `gstashp`, `gfixup`, `gcp`
- Navi: `Ctrl+G` widget + cheats in `cheats/`
- Tmux: oh-my-tmux + TPM + `config/tmux.conf.local`
- MOTD: hostname-based scripts in `motd/`

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
- `DOTFILES_ENABLE_AUTOUPDATE`
- `DOTFILES_ENABLE_TMUX_AUTOSTART`
- `DOTFILES_ENABLE_SSH_TMUX_RENAME`
- `DOTFILES_ENABLE_IOBROKER`

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
- `USER@HOST`: `\u@\h` (User/Host). User ist hellblau (root rot), Host blau.
- `(IP)`: eine IPv4-Adresse (nur wenn gefunden). Ermittelt einmal beim Laden von `components/bash_prompt` via `ip a` und gefiltert (kein `127.*`, kein `172.*`, kein `100.*`).
- `CWD`: `\w` (aktuelles Verzeichnis), orange.
- `(PERMS)`: Rechte des aktuellen Verzeichnisses via `stat -c %a .` (z.B. `755`).
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
- `(IP)`: bevorzugt bei SSH die Server-IP aus `SSH_CONNECTION`, sonst wird per `ip -4 a` (oder fallback `hostname -I`) eine IPv4 gesucht (ähnliche Filter wie bash).
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

## FZF extras

Enabled by default via `DOTFILES_ENABLE_FZF_EXTRAS`.

- `fh`: pick a command from history via `fzf`
- `cdf`: pick a directory via `fzf` and `cd` into it
- `DOTFILES_ENABLE_FZF_HISTORY_BINDINGS`: when enabled, binds `Ctrl+R` to the `fh` picker (bash + zsh)
- `DOTFILES_ENABLE_FZF_CDF_BINDING`: when enabled, binds `Alt+C` to the `cdf` picker (bash + zsh)

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

### Bash

| Key                                      | Function                        |
| :--------------------------------------- | :------------------------------ |
| <kbd>CTRL</kbd> + <kbd>A</kbd>           | jump to the beginning of a line |
| <kbd>CTRL</kbd> + <kbd>E</kbd>           | jump to the end of the line     |
| <kbd>CTRL</kbd> + <kbd>R</kbd>           | reverse-search                  |
| <kbd>CTRL</kbd> + <kbd>C</kbd>           | interrupt command               |
| <kbd>CTRL</kbd> + <kbd>L</kbd>           | clear screen                    |
| <kbd>ALTGR</kbd> + <kbd>Mousewheel</kbd> | bash history                    |

### Navi

| Key                            | Function       |
| :----------------------------- | :------------- |
| <kbd>CTRL</kbd> + <kbd>G</kbd> | show navi menu |

### tmux

Prefix is <kbd>CTRL</kbd> + <kbd>a</kbd>

| Key                                                | Function                                   |
| :------------------------------------------------- | :----------------------------------------- |
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
| <kbd>SHIFT</kbd> + <kbd>LEFT</kbd>                 | switch to left window                      |
| <kbd>SHIFT</kbd> + <kbd>RIGHT</kbd>                | switch to right window                     |
| <kbd>PREFIX</kbd> + <kbd>z</kbd>                   | pane > fullscreen                          |
| <kbd>PREFIX</kbd> + <kbd>r</kbd>                   | reload tmux.conf                           |
| <kbd>F11</kbd>                                     | pane > fullscreen                          |
| <kbd>PREFIX</kbd> + <kbd>?</kbd>                   | list shortcuts                             |
| <kbd>ALT</kbd> + <kbd>LEFT</kbd>                   | switch to the left pane                    |
| <kbd>ALT</kbd> + <kbd>RIGHT</kbd>                  | switch to the right pane                   |
| <kbd>ALT</kbd> + <kbd>UP</kbd>                     | switch to the upper pane                   |
| <kbd>ALT</kbd> + <kbd>DOWN</kbd>                   | switch to the lower pane                   |
| <kbd>PREFIX</kbd> + <kbd>CTRL</kbd> + <kbd>s</kbd> | save tmux environment to ~/.tmux/resurrect |
| <kbd>PREFIX</kbd> + <kbd>CTRL</kbd> + <kbd>r</kbd> | restore tmux environment                   |
| <kbd>PREFIX</kbd> + <kbd>$</kbd>                   | rename session                             |
