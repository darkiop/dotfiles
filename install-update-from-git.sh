#!/bin/bash

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