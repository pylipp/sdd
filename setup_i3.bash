#! /bin/bash

# Installation script for i3 and tools (dunst, i3lock-color, bumblebee-status)
# Installation location: /usr and ~/software
# Requires: - git
#           - make

set -e

source $(dirname "$0")/utils.bash

main() {
    local method=${1:-global}

    if [[ $method = "global" ]]; then
        echo_install_info i3

        install_packages git build-essential
        install_packages i3 xautolock xorg xinit feh imagemagick xrandr arandr

        mkcswdir

        # install dunst from source. v1.1.0 from the debian repos is outdated
        install_packages libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev \
            libglib2.0-dev libpango1.0-dev libgtk-3-dev libxdg-basedir-dev
        git clone https://github.com/dunst-project/dunst
        cd dunst
        git checkout v1.2.0
        make
        sudo make install

        cd ..
        install_packages pkg-config libxcb1 libpam-dev libcairo-dev \
            libxcb-xinerama0-dev libev-dev libx11-dev libx11-xcb-dev libxkbcommon0 \
            libxkbcommon-x11-0 libxcb-dpms0-dev libxcb-image0-dev libxcb-util0-dev \
            libxcb-xkb-dev libxkbcommon-x11-dev libxkbcommon-dev dbus-x11
        git clone https://github.com/chrjguill/i3lock-color
        cd i3lock-color 
        sudo make install 
        cd ~/.files/i3/i3lock-fancy
        git checkout multimonitor
    elif [[ $method = "local" ]]; then
        echo_warn "Sorry, local i3 installation is not possible."
    else
        echo_error "Unknown method '$method'!"
        exit 1
    fi
}

main "$@"
