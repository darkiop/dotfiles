# dotfiles
dotfiles for bash

## INSTALL

### with menu

```
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install/install.sh')"
```

### install all without questions

```
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install/install.sh')" '' all
```

### clone the repo
```
git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
bash $HOME/dotfiles/install/install.sh
```

## FEATURES
- navi <kbd>STRG</kbd> + <kbd>G</kbd> (~/dotfiles/cheats)
- cheat.sh
```
cht.sh man
```
- vimrc
- motd for each hostname (~/dotfiles/motd)
- byobu
- dategrep
```
dategrep --start "12:00" --end "12:15" syslog
dategrep --end "12:15" --format "%b %d %H:%M:%S" syslog
dategrep --last-minutes 5 syslog
cat syslog | dategrep --end "12:15"
```

## LINKS (used and not used in my dotfiles)

### inspired by other dotfile projects
- https://github.com/1995parham/dotfiles
- https://github.com/denisidoro/dotfiles

### projects used by my dotfiles
- https://github.com/koljah-de/simple-bash-prompt
- https://github.com/chubin/cheat.sh
- https://github.com/denisidoro/navi
- https://github.com/Peltoche/lsd
- https://github.com/sharkdp/bat
- https://github.com/amix/vimrc
- https://github.com/mdom/dategrep
- http://lnav.org

### misc
- https://github.com/vim-airline/vim-airline
- https://github.com/vim-airline/vim-airline-themes
- https://github.com/starship/starship
- https://github.com/Eugeny/terminus
- https://github.com/ryanoasis/nerd-fonts
- https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack#quick-installation
- https://github.com/ranger/ranger
- https://github.com/brantb/solarized
- https://github.com/Bash-it/bash-it
- https://github.com/tmux
- https://github.com/seebi/dircolors-solarized
- https://github.com/clvv/fasd
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
- https://github.com/LeCoupa/awesome-cheatsheets/blob/master/languages/bash.sh
- https://github.com/aristocratos/bashtop
- https://github.com/reujab/silver
- https://github.com/existme/notes
- https://drasite.com/blog/Pimp%20my%20terminal#top-from-the-future
- https://ichi.pro/de/das-essential-bash-spickzettel-15514461037920
- https://wiki.ubuntuusers.de/Bash/Prompt
- https://www.linux.com/learn/enhancing-virtual-terminals-byobu

## KEY BINDINGS

### bash

Key | Function
:--- | :---
<kbd>CTRL</kbd> + <kbd>A</kbd> | jump to the beginning of a line
<kbd>CTRL</kbd> + <kbd>E</kbd> | jump to the end of the line
<kbd>CTRL</kbd> + <kbd>R</kbd> | reverse-search
<kbd>CTRL</kbd> + <kbd>C</kbd> | interupt command
<kbd>CTRL</kbd> + <kbd>L</kbd> | clear screen

### navi

Key | Function
:--- | :---
<kbd>CTRL</kbd> + <kbd>G</kbd> | show navi menu

### byobu

Key | Function
:--- | :---
<kbd>F2</kbd> | Create a new window
<kbd>F3</kbd> | Move to the previous window
<kbd>F4</kbd> | Move to the next window
<kbd>F5</kbd> | Refresh all status notifications
<kbd>F6</kbd> | Detach from the session and logout
<kbd>SHIFT</kbd> + <kbd>F6</kbd>| Detach from the session, but do not logout
<kbd>F7</kbd> | Enter scrollback/search mode
<kbd>F8</kbd> | Rename the current window
<kbd>F9</kbd> | Launch the Byobu Configuration Menu
<kbd>F12</kbd> | GNU Screen's Escape Key
<kbd>ALT</kbd> + <kbd>Pageup</kbd> | Scroll back through this window's history
<kbd>Alt</kbd> + <kbd>Pagedown</kbd> | Scroll forward through this window's history
<kbd>SHIFT</kbd> + <kbd>F2</kbd> | Split the screen horizontally
<kbd>CTRL</kbd> + <kbd>F2</kbd> | Split the screen vertically
<kbd>SHIFT</kbd> + <kbd>F3</kbd> | Move focus to the next split
<kbd>SHIFT</kbd> + <kbd>F4</kbd> | Move focus to the previous split
<kbd>SHIFT</kbd> + <kbd>F5</kbd> | Collapse all splits
<kbd>CTRL</kbd> + <kbd>F5</kbd> | Reconnect any SSH/GPG sockets or agents
<kbd>SHIFT</kbd> + <kbd>F12</kbd> | Toggle all of Byobu's keybindings on or off