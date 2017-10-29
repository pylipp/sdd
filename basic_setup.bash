#!/bin/bash

# This assumes that vim, tmux, wget, curl, git, zsh are available on your machine

# Don't run this inside tmux or plugin installation will fail
if [[ ! -z $TMUX ]]; then
    echo Please quit tmux!
    exit
fi

cd
ln -s .files/tmux.conf .tmux.conf

cd .files
bash generate_vimrc.sh 
cd
ln -s .files/vim .vim
vim +qa
vim +PlugInstall < /dev/tty

cd
mkdir -p .tmux/plugins
git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
cd .tmux/plugins/tpm/bin
./install_plugins 
 
cd
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sed -i 's/env zsh//g' install.sh
./install.sh
rm -rf .zshrc* install.sh
ln -s .files/zshrc .zshrc
ln -s .files/oh-my-zsh/themes/bullet-train.zsh-theme .oh-my-zsh/themes/bullet-train.zsh-theme
chsh -s $(which zsh) || echo exec zsh >> .bashrc

ln -s .files/dir_colors .dir_colors
ln -s .files/gitconfig .gitconfig
echo "Set up .files/global_gituser!"
