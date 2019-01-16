#! /bin/bash

# Installation script for ripgrep
# Installation location: /usr (or ~/.local)
# Requires: - wget
#           - tar (local installation)

set -e

source $(dirname "$0")/utils.bash

main() {
    local method=${1:-global}

    echo_install_info ripgrep
    mkcswdir

    local ripgrep_version=0.10.0
    local package_name
    local github_url=https://github.com/BurntSushi/ripgrep/releases/download/$ripgrep_version

    if [[ $method = "global" ]]; then
        package_name=ripgrep_$ripgrep_version\_amd64.deb
        wget $github_url/$package_name
        sudo dpkg --install $package_name
        rm $package_name
    elif [[ $method = "local" ]]; then
        package_name=ripgrep-$ripgrep_version-x86_64-unknown-linux-musl
        wget $github_url/$package_name.tar.gz
        tar xf $package_name.tar.gz
        cp $package_name/rg "$HOME"/.local/bin
        rm -rf $package_name.tar.gz $package_name
    else
        echo_error "Unknown method '$method'!"
        exit 1
    fi

}

main "$@"
