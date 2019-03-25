#!/bin/bash

# Installation script for watson
# Installation location: $WORKON_HOME/watson
# Requires: - python-virtualenv
#           - wget

set -e

WATSON_VERSION=1.6.0

main() {
    if [[ $1 = "install" ]]; then
        python -m virtualenv --python=$(which python3) $WORKON_HOME/watson
        source $WORKON_HOME/watson/bin/activate
        pip install td-watson==$WATSON_VERSION
        ln -s $WORKON_HOME/watson/bin/watson ~/.local/bin
        wget -O ~/.local/share/zsh/site-functions/_watson https://github.com/TailorDev/Watson/blob/$WATSON_VERSION/watson.zsh-completion
        mkdir -p ~/.config/watson
        ln -s ~/.files/watson_config ~/.config/watson/config

    elif [[ "$1" = "update" ]]; then
        source $WORKON_HOME/watson/bin/activate
        pip install -U td-watson==$WATSON_VERSION
        wget -N -O ~/.local/share/zsh/site-functions/_watson https://github.com/TailorDev/Watson/blob/$WATSON_VERSION/watson.zsh-completion

    elif [[ "$1" = "remove" ]]; then
        rm -rfv ~/.local/bin/watson $WORKON_HOME/watson ~/.local/share/zsh/site-functions/_watson ~/.config/watson/config
        # Not removing ~/.config/watson because it contains data that still
        # might be useful

    else
        echo "No or incorrect command given: $*"
        echo "Select one of: install | update | remove"
    fi
}

main "$@"
