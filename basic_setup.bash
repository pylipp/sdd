#!/bin/bash

# Don't run this inside tmux or plugin installation will fail

set -e

if [[ ! -z $TMUX ]]; then
    echo Please quit tmux!
    exit
fi

source $(dirname "$0")/utils.bash

# assume that vim is already installed
install_packages wget git zsh gcc g++ make xclip

cd

ln -s .files/vimrc .vimrc
ln -s .files/vim .vim
vim +qa
vim +PlugInstall < /dev/tty

sdd install oh-my-zsh tmux

ln -s .files/dir_colors .dir_colors
ln -s .files/gitconfig .gitconfig
echo "Set up .files/global_gituser!"
