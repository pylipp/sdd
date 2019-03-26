#!/bin/bash

# Installation script for hub
# Installation location: ~/.local
# Requires: - tar
#           - wget

set -e

HUB_VERSION=2.10.0

main() {
    if [[ $1 = "install" ]]; then
        local ARCH=amd64
        if [[ $(arch) = armv7l ]]; then
            ARCH=arm
        fi

        local hub_dir=hub-linux-"$ARCH"-$HUB_VERSION
        wget https://github.com/github/hub/releases/download/v$HUB_VERSION/$hub_dir.tgz
        tar xf $hub_dir.tgz
        PREFIX=~/.local $hub_dir/install
        cp $hub_dir/etc/hub.zsh_completion ~/.local/share/zsh/site-functions/_hub
        rm -rf $hub_dir $hub_dir.tgz

    elif [[ "$1" = "update" ]]; then
        main remove
        main install

    elif [[ "$1" = "remove" ]]; then
        rm -rfv ~/.local/bin/hub ~/.local/share/vim/**/pullrequest.vim ~/.local/share/man/man1/hub* ~/.local/share/zsh/site-functions/_hub

    else
        echo "No or incorrect command given: $*"
        echo "Select one of: install | update | remove"
        exit 1
    fi
}

main "$@"
