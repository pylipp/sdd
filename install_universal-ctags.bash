#! /bin/bash

set -e

source $(dirname "$0")/utils.bash

main() {
    local method=${1:-global}

    echo_install_info universal-ctags
    mkcswdir

    git clone https://github.com/universal-ctags/ctags
    cd ctags

    if [[ $method = "global" ]]; then
        sudo apt-get remove exuberant-ctags
        ./configure
        make
        sudo make install
    elif [[ $method = "local" ]]; then
        ./configure --prefix=$HOME/.local
        make
        make install
    else
        echo_error "Unknown method '$method'!"
        exit 1
    fi
}

main "$@"
