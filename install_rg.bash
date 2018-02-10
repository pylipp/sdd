#! /bin/bash

# Installation script for ripgrep
# Installation location: /usr/local (or ~/.local)
# Requires: - wget
#           - tar

set -e

source $(dirname "$0")/utils.bash

main() {
    local method=${1:-global}

    echo_install_info ripgrep
    mkcswdir

    local ripgrep_version=0.7.1
    wget https://github.com/BurntSushi/ripgrep/releases/download/$ripgrep_version/ripgrep-$ripgrep_version-x86_64-unknown-linux-musl.tar.gz
    tar xf ripgrep-$ripgrep_version-x86_64-unknown-linux-musl.tar.gz

    if [[ $method = "global" ]]; then
        sudo cp ripgrep-$ripgrep_version-x86_64-unknown-linux-musl/rg /usr/local/bin
        sudo cp ripgrep-$ripgrep_version-x86_64-unknown-linux-musl/complete/_rg /usr/share/zsh/site-functions
    elif [[ $method = "local" ]]; then
        cp ripgrep-$ripgrep_version-x86_64-unknown-linux-musl/rg $HOME/.local/bin
    else
        echo_error "Unknown method '$method'!"
        exit 1
    fi

    rm -rf ripgrep-$ripgrep_version-x86_64-unknown-linux-musl.tar.gz ripgrep-$ripgrep_version-x86_64-unknown-linux-musl
}

main "$@"
