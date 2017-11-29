#! /bin/bash

# Installation script for tmux and plugins
# Installation location: /usr and ~/.tmux
# Requires: - git
#           - pip
#           - make/cmake

set -e

source ~/.files/setup/utils.bash


main() {
    local method=${1:-global}

    echo_install_info tmux

    if [[ $method = "global" ]]; then
        install_packages tmux xclip build-essential cmake
    elif [[ $method = "local" ]]; then
        # hope that these are installed...
        # install_packages automake libevent-dev
        mkcswdir
        git clone https://github.com/tmux/tmux
        cd tmux
        git checkout 2.6
        sh autogen.sh
        ./configure --prefix="$HOME"/.local
        make
        make install
    else
        echo_error "Unknown method '$method'!"
        exit 1
    fi

    [[ $(command -v tmux >/dev/null 2>&1) ]] || ( echo_error "Tmux not installed!"; exit 1; )

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    pip install --user tmuxp

    # set up config files for plugin installation
    mv_existing ~/.tmux.conf
    mv_existing ~/.tmuxp
    ln -s ~/.files/tmux.conf ~/.tmux.conf
    ln -s ~/.files/tmuxp ~/.tmuxp

    cd ~/.tmux/plugins
    tpm/bin/install_plugins

    # check out custom branch
    cd tmux-mem-cpu-load
    git checkout feature/temperature
    # issue warning; tmux-mem-cpu-load pluging requires cmake
    [[ $(command -v cmake >/dev/null 2>&1) ]] || echo_error "cmake not installed!"
}

main "$@"
