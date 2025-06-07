# my.dotfiles

dotfiles for bash

## INSTALL

### With menu

```bash
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')"
```

### Without questions

```bash
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')" '' all
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')" '' all load-bashrc
```

### Clone

```bash
git clone https://github.com/darkiop/dotfiles ~/dotfiles
bash ~/dotfiles/install.sh
```

## FEATURES

```bash
- navi <kbd>STRG</kbd> + <kbd>G</kbd> (~/dotfiles/cheats)
- vimrc
- motd for each hostname (~/dotfiles/motd)
- dategrep
- tmux

dategrep --start "12:00" --end "12:15" syslog
dategrep --end "12:15" --format "%b %d %H:%M:%S" syslog
dategrep --last-minutes 5 syslog
cat syslog | dategrep --end "12:15"
```

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
| <kbd>CTRL</kbd> + <kbd>C</kbd>           | interupt command                |
| <kbd>CTRL</kbd> + <kbd>L</kbd>           | clear screen                    |
| <kbd>ALTGR</kbd> + <kbd>Mousewhell</kbd> | bash history                    |

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
