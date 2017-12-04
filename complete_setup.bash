#! /bin/bash

set -e 

method=${1:-global}

if [[ $method = "global" ]]; then
    sudo apt-get update && sudo apt-get upgrade -y
    sudo cp "$HOME/.files/keyboard" /usr/share/X11/xkb/symbols/pylipp
    setxkbmap pylipp
fi

for step in install_core_utils setup_zsh setup_python install_vim setup_tmux install_st; do
    bash $HOME/.files/setup/$step.bash $method
done

bash $HOME/.files/setup/setup_links.bash
