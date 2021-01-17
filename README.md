# dotfiles
dotfiles for bash

![Screenshot](screenshot.png)
Screenshot with Terminal https://github.com/Eugeny/terminus

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
- cheat.sh (example, run: "cht.sh man")
- vimrc
- motd for each hostname (~/dotfiles/motd)
- byobu

## LINKS (used and not used in my dotfiles)

### other dotfile projects
- https://github.com/1995parham/dotfiles
- https://github.com/denisidoro/dotfiles

### other tools in use
- https://github.com/koljah-de/simple-bash-prompt
- https://github.com/chubin/cheat.sh
- https://github.com/denisidoro/navi
- https://github.com/Peltoche/lsd
- https://github.com/sharkdp/bat
- https://github.com/amix/vimrc
- http://lnav.org

### other
- https://github.com/vim-airline/vim-airline
- https://github.com/vim-airline/vim-airline-themes
- https://github.com/starship/starship
- https://github.com/Eugeny/terminus
- https://github.com/ryanoasis/nerd-fonts
- https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack#quick-installation
- https://github.com/ranger/ranger
- https://wiki.ubuntuusers.de/Bash/Prompt
- https://github.com/brantb/solarized
- https://github.com/Bash-it/bash-it
- https://github.com/tmux
- https://github.com/seebi/dircolors-solarized
- https://github.com/clvv/fasd
- https://www.linux.com/learn/enhancing-virtual-terminals-byobu
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
- https://github.com/LeCoupa/awesome-cheatsheets/blob/master/languages/bash.sh
- https://github.com/aristocratos/bashtop
- https://drasite.com/blog/Pimp%20my%20terminal#top-from-the-future
- https://ichi.pro/de/das-essential-bash-spickzettel-15514461037920
- https://github.com/reujab/silver
- https://github.com/existme/notes

## KEY BINDINGS

### navi

Key | Function
:--- | :---
<kbd>STRG + G</kbd> | show navi menu

### byobu

Key | Function
:--- | :---
<kbd>F2</kbd> | Create a new window
<kbd>F3</kbd> | Move to the previous window
<kbd>F4</kbd> | Move to the next window
<kbd>F5</kbd> | Refresh all status notifications
<kbd>F6</kbd> | Detach from the session and logout
<kbd>Shift</kbd> + <kbd>F6</kbd>| Detach from the session, but do not logout
<kbd>F7</kbd> | Enter scrollback/search mode
<kbd>F8</kbd> | Rename the current window
<kbd>F9</kbd> | Launch the Byobu Configuration Menu
<kbd>F12</kbd> | GNU Screen's Escape Key
<kbd>Alt-Pageup</kbd> | Scroll back through this window's history
<kbd>Alt-Pagedown</kbd> | Scroll forward through this window's history
<kbd>Shift-F2</kbd> | Split the screen horizontally
<kbd>Ctrl-F2</kbd> | Split the screen vertically
<kbd>Shift-F3</kbd> | Move focus to the next split
<kbd>Shift-F4</kbd> | Move focus to the previous split
<kbd>Shift-F5</kbd> | Collapse all splits
<kbd>Ctrl-F5</kbd> | Reconnect any SSH/GPG sockets or agents
<kbd>Shift-F12</kbd> | Toggle all of Byobu's keybindings on or off