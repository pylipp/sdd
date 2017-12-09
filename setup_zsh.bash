#! /bin/bash

# Installation script for zsh and oh-my-zsh
# Installation location: /usr and ~/.oh-my-zsh
# Requires: - wget

set -e

source $(dirname "$0")/utils.bash


main() {
    local method=${1:-global}

    if [[ $method = "global" ]]; then
        install_packages zsh wget
    elif [[ $method != "local" ]]; then
        echo_error "Unknown method '$method'!"
        exit 1
    fi

    echo_install_info zsh

    cd
    wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

    # don't execute zsh when installation is done
    sed -i 's/env zsh//g' install.sh

    chmod +x install.sh
    # The installation script will attempt to change the default shell which will fail if you
    # don't have sudo rights.
    # Hence we use a trick (see https://unix.stackexchange.com/a/136424/192726)
    ./install.sh || echo -e 'export SHELL=$(which zsh)\n[ -z "$ZSH_VERSION" ] && exec "$SHELL" -l' >> ~/.profile
    # Apparently, this comment was once helpful, too; so I'm keeping it:
    # https://github.com/robbyrussell/oh-my-zsh/issues/1224#issuecomment-31623113
    # This workaround might be required:
    # sudo sed -i 's/^auth[[:space:]]*required/#auth required/' /etc/pam.d/chsh

    for file in install.sh .zshrc .zshrc.pre-oh-my-zsh; do
        rm_existing "$file"
    done

    ln -s .files/zshrc .zshrc
    ln -s ~/.files/oh-my-zsh/themes .oh-my-zsh/custom/themes
}

main "$@"
