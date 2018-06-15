#! /bin/bash

# Installation script for bat
# Installation location: /usr/local (or ~/.local)
# Requires: - git
#           - wget
#           - tar

set -e

source $(dirname "$0")/utils.bash


main() {
    local method=${1:-global}

    local bat_version=0.4.1
    local bat_dir=bat-v$bat_version-x86_64-unknown-linux-gnu
    local bat_tar=$bat_dir.tar.gz

    echo_install_info bat
    mkcswdir
    wget https://github.com/sharkdp/bat/releases/download/v$bat_version/$bat_tar
    tar xf $bat_tar

    if [[ $method = "global" ]]; then
        sudo mv $bat_dir/bat /usr/local/bin
    elif [[ $method = "local" ]]; then
        mv $bat_dir/bat ~/.local/bin
    else
        echo_error "Unknown method '$method'!"
        exit 1
    fi

    # https://github.com/sharkdp/bat/issues/34#issuecomment-385634632
    # Get theme
    mkdir -p ~/.config/bat/themes
    cd ~/.config/bat/themes
    git clone https://github.com/braver/Solarized
    ln -sf "Solarized/Solarized (dark).tmTheme" Default.tmTheme

    # Get language definition files
    mkdir -p ~/.config/bat/syntaxes
    cd ~/.config/bat/syntaxes
    git clone https://github.com/sublimehq/Packages/
    rm -rf Packages/Markdown
    git clone https://github.com/jonschlinkert/sublime-markdown-extended

    # Initialize cache
    bat cache --init

    # clean up
    rm -rf $bat_tar $bat_dir
}

main "$@"
