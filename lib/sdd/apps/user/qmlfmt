#! /bin/bash

# Installation script for qmlfmt
# Installation location: /usr/local (or ~/.local)
# Requires: - wget
#           - tar (local installation)

set -e

source $(dirname "$0")/utils.bash

main() {
    local method=${1:-global}

    echo_install_info qmlfmt
    mkcswdir

    local qmlfmt_version=1.0.71
    local tarfile=qmlfmt.tar.gz
    local github_url=https://github.com/jesperhh/qmlfmt/releases/download/$qmlfmt_version/$tarfile

    wget $github_url
    tar xf $tarfile

    if [[ $method = "global" ]]; then
        sudo mv qmlfmt /usr/local/bin
    elif [[ $method = "local" ]]; then
        mv qmlfmt ~/.local/bin
    else
        echo_error "Unknown method '$method'!"
        exit 1
    fi

    rm $tarfile
}

main "$@"
