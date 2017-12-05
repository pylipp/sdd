#! /bin/bash

set -e 

method=${1:-global}

if [[ $method = "global" ]]; then
    sudo apt-get update && sudo apt-get upgrade -y
    sudo cp "$HOME/.files/keyboard" /usr/share/X11/xkb/symbols/pylipp
    setxkbmap pylipp
elif [[ $method = "local" ]]; then
    mkdir -p ~/.config/xkb/symbols
    ln -s ~/.files/keyboard ~/.config/xkb/symbols/pylipp
    cd ~/.config/xkb
    # worked: http://www.gabriel.urdhr.fr/2014/06/06/custom-keyboard/
    # did not work: https://unix.stackexchange.com/questions/397716/custom-keyboard-layout-without-root?rq=1
    setxkbmap pylipp pylipp -print | xkbcomp -I. - $DISPLAY
    cd -
else
    echo_error "Unknown method '$method'!"
    exit 1
fi

for step in install_core_utils setup_zsh setup_python install_vim setup_tmux install_st; do
    bash $HOME/.files/setup/$step.bash $method
done

bash $HOME/.files/setup/setup_links.bash
