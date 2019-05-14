#!/bin/bash

# This assumes that vim, tmux, wget, curl, git, zsh are available on your machine

# Don't run this inside tmux or plugin installation will fail

set -e

if [[ ! -z $TMUX ]]; then
    echo Please quit tmux!
    exit
fi

source $(dirname "$0")/utils.bash

install_packages tmux wget curl git zsh

cd
ln -s .files/tmux.conf .tmux.conf

ln -s .files/vimrc .vimrc
ln -s .files/vim .vim
vim +qa
vim +PlugInstall < /dev/tty

cd
mkdir -p .tmux/plugins
install_packages cmake build-essential xclip
git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
cd .tmux/plugins/tpm
bin/install_plugins 
cd ../tmux-mem-cpu-load
git checkout feature/temperature
 
sdd install oh-my-zsh

ln -s .files/dir_colors .dir_colors
ln -s .files/gitconfig .gitconfig
echo "Set up .files/global_gituser!"
