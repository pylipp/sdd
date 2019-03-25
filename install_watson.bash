#!/bin/bash

# Installation script for watson
# Installation location: $WORKON_HOME/watson
# Requires: - python3-virtualenv
#           - wget
#           - git

set -e

WATSON_VERSION=aa901567c5aa6129ff6dae799eddbfb0be06cb65

main() {
    if [[ $1 = "install" ]]; then
        python3 -m virtualenv --python=$(which python3) $WORKON_HOME/watson
        source $WORKON_HOME/watson/bin/activate
        pip install git+https://github.com/TailorDev/Watson@$WATSON_VERSION\#egg=Watson

        mkdir -p ~/.local/bin
        ln -s $WORKON_HOME/watson/bin/watson ~/.local/bin

        mkdir -p ~/.local/share/zsh/site-functions
        wget -O ~/.local/share/zsh/site-functions/_watson https://raw.githubusercontent.com/TailorDev/Watson/$WATSON_VERSION/watson.zsh-completion

        mkdir -p ~/.config/watson
        ln -s ~/.files/watson_config ~/.config/watson/config

    elif [[ "$1" = "update" ]]; then
        source $WORKON_HOME/watson/bin/activate
        pip install --upgrade git+https://github.com/TailorDev/Watson@$WATSON_VERSION\#egg=Watson

        wget -O ~/.local/share/zsh/site-functions/_watson https://raw.githubusercontent.com/TailorDev/Watson/$WATSON_VERSION/watson.zsh-completion

    elif [[ "$1" = "remove" ]]; then
        rm -rfv ~/.local/bin/watson $WORKON_HOME/watson ~/.local/share/zsh/site-functions/_watson ~/.config/watson/config
        # Not removing ~/.config/watson because it contains data that still
        # might be useful

    else
        echo "No or incorrect command given: $*"
        echo "Select one of: install | update | remove"
        exit 1
    fi
}

main "$@"
