# dotfiles
dotfiles for bash

## INSTALL

### with menu

```
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')"
```

### install all without questions

```
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')" '' all
bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install.sh')" '' all load-bashrc
```

### clone the repo
```
git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
bash $HOME/dotfiles/install.sh
```

## FEATURES
- navi <kbd>STRG</kbd> + <kbd>G</kbd> (~/dotfiles/cheats)
- cheat.sh
```
cht.sh man
```
- vimrc
- motd for each hostname (~/dotfiles/motd)
- dategrep
- tmux
```
dategrep --start "12:00" --end "12:15" syslog
dategrep --end "12:15" --format "%b %d %H:%M:%S" syslog
dategrep --last-minutes 5 syslog
cat syslog | dategrep --end "12:15"
```

## LINKS

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
- https://www.cheatsheet.wtf/bash/
- https://shellmagic.xyz
- https://github.com/jlevy/the-art-of-command-line/blob/master/README-de.md

## terminal
- https://github.com/Eugeny/tabby

## KEY BINDINGS

### bash

Key | Function
:--- | :---
<kbd>CTRL</kbd> + <kbd>A</kbd> | jump to the beginning of a line
<kbd>CTRL</kbd> + <kbd>E</kbd> | jump to the end of the line
<kbd>CTRL</kbd> + <kbd>R</kbd> | reverse-search
<kbd>CTRL</kbd> + <kbd>C</kbd> | interupt command
<kbd>CTRL</kbd> + <kbd>L</kbd> | clear screen
<kbd>ALTGR</kbd> + <kbd>Mousewhell</kbd> | bash history

### navi

Key | Function
:--- | :---
<kbd>CTRL</kbd> + <kbd>G</kbd> | show navi menu

### tmux
Prefix is <kbd>CTRL</kbd> + <kbd>a</kbd>

Key | Function
:--- | :---
<kbd>PREFIX</kbd> + <kbd><</kbd> | Split the screen vertically
<kbd>PREFIX</kbd> + <kbd>-</kbd> | Split the screen horizontally
<kbd>PREFIX</kbd> + <kbd>c</kbd> | create a new window
<kbd>PREFIX</kbd> + <kbd>t</kbd> | create a new window
<kbd>PREFIX</kbd> + <kbd>w</kbd> | close the window
<kbd>PREFIX</kbd> + <kbd>s</kbd> | show windows
<kbd>PREFIX</kbd> + <kbd>,</kbd> | rename window
<kbd>PREFIX</kbd> + <kbd>d</kbd> | detach session
<kbd>PREFIX</kbd> + <kbd>TAB</kbd> | switch between last and current window
<kbd>SHIFT</kbd> + <kbd>LEFT</kbd> | switch to left window
<kbd>SHIFT</kbd> + <kbd>RIGHT</kbd> | switch to right window
<kbd>PREFIX</kbd> + <kbd>z</kbd> | pane > fullscreen
<kbd>PREFIX</kbd> + <kbd>r</kbd> | reload tmux.conf
<kbd>F11</kbd> | pane > fullscreen
<kbd>PREFIX</kbd> + <kbd>?</kbd> | list shortcuts
<kbd>ALT</kbd> + <kbd>LEFT</kbd> | switch to the left pane
<kbd>ALT</kbd> + <kbd>RIGHT</kbd> | switch to the right pane
<kbd>ALT</kbd> + <kbd>UP</kbd> | switch to the upper pane
<kbd>ALT</kbd> + <kbd>DOWN</kbd> | switch to the lower pane
<kbd>PREFIX</kbd> + <kbd>CTRL</kbd> + <kbd>s</kbd> | save tmux environment to ~/.tmux/resurrect
<kbd>PREFIX</kbd> + <kbd>CTRL</kbd> + <kbd>r</kbd> | restore tmux environment
<kbd>PREFIX</kbd> + <kbd>$</kbd> | rename session