#! /bin/bash

# Installation script for core tools
# Installation location: /usr and ~/
# Requires: - git

set -e

source $(dirname "$0")/utils.bash

main() {
    local method=${1:-global}

    if [[ $method = "global" ]]; then
        echo_install_info "core utils"

        # development utilities
        install_packages \
            g++ cmake build-essential doxygen graphviz python-dev exuberant-ctags
        # workflow
        install_packages tig tmux direnv silversearcher-ag xclip
        # system utilities
        install_packages network-manager usbmount lm-sensors htop
        # libraries
        install_packages libxml2-dev libxslt-dev libxml2-utils libxcb-composite0-dev
        # sound support
        install_packages pulseaudio libasound2-dev alsa-utils
        # base utilities
        install_packages wget curl gawk scrot zip unzip 

        echo_install_info fzf
        # preview colorizer
        install_packages coderay
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all

        # make automounted devices readable for user
        # https://unix.stackexchange.com/a/155689/192726
        if [[ -e /etc/usbmount/usbmount.conf ]]; then
            sudo sed -i -r 's/(^MOUNTOPTIONS=".*)"/\1,uid=1000,gid=1000"/' /etc/usbmount/usbmount.conf
        fi

        # make zathura default application to open pdfs using xdg-open
        xdg-mime default zathura.desktop application/pdf

    elif [[ $method = "local" ]]; then
        echo_warn "Sorry, local core utils installation is not possible."
    else
        echo_error "Unknown method '$method'!"
        exit 1
    fi
}

main "$@"
