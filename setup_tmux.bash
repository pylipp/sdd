#! /bin/bash

# Installation script for tmux and plugins
# Installation location: /usr (or ~/.local) and ~/.tmux
# Requires: - git
#           - pip
#           - make/cmake

set -e

source $(dirname "$0")/utils.bash


main() {
    local method=${1:-global}

    echo_install_info tmux

    if [[ $method = "global" ]]; then
        install_packages tmux xclip build-essential cmake
    elif [[ $method = "local" ]]; then
        # install from gist
        mkcswdir
        wget https://gist.githubusercontent.com/pylipp/ea5f830532e0c38ff70055cf7337fc43/raw/1117c92060df458cf5d4a7b361333df42094f5bc/install.sh
        chmod +x install.sh
        ./install.sh 2.6
        rm -rf install.sh
        cd -
    else
        echo_error "Unknown method '$method'!"
        exit 1
    fi

    [[ $(command -v tmux >/dev/null 2>&1) ]] || ( echo_error "Tmux not installed!"; exit 1; )

    git clone https://github.com/ashneo76/tpm --branch customizations ~/.tmux/plugins/tpm
    pip install --user tmuxp

    # set up config files for plugin installation
    mv_existing ~/.tmux.conf
    mv_existing ~/.tmuxp
    ln -s ~/.files/tmux.conf ~/.tmux.conf
    ln -s ~/.files/tmuxp ~/.tmuxp

    cd ~/.tmux/plugins
    tpm/bin/install_plugins

    # issue warning; tmux-mem-cpu-load pluging requires cmake
    [[ $(command -v cmake >/dev/null 2>&1) ]] || echo_error "cmake not installed!"
}

main "$@"
