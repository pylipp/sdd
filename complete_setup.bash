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

sdd install oh-my-zsh tmux pip direnv
sdd install watson=aa901567c5aa6129ff6dae799eddbfb0be06cb65

for step in install_core_utils install_vim install_st; do
    bash $HOME/.files/setup/$step.bash $method
done

bash $HOME/.files/setup/setup_links.bash
