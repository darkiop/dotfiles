#!/bin/bash

git status > /dev/null 2>&1 &

if git diff-index --quiet HEAD --; then
    echo 'No changes'
    cd ~/dotfiles
    git pull
    cd ~
    bash ~/.bashrc
else
    echo 'Changes'
fi

# EOF