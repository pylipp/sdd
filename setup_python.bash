#! /bin/bash

# Installation script for pip and virtualenvwrapper
# Installation location: ~/.local
# Requires: - wget
#           - python3 or python2

set -e

source ~/.files/setup/utils.bash

main() {
    local method=${1:-global}

    if [[ $method = "global" ]]; then
        sudo apt-get --purge -y remove python-pip python3-pip python-virtualenv python3-virtualenv virtualenvwrapper
        install_packages python3.5 wget
    elif [[ $method != "local" ]]; then
        echo_error "Unknown method '$method'!"
        exit 1
    fi

    echo_install_info pip
    # https://pip.pypa.io/en/latest/installing/
    wget https://bootstrap.pypa.io/get-pip.py

    if command -v python3 >/dev/null 2>&1; then
        python3 get-pip.py --user
    elif command -v python2 >/dev/null 2>&1; then
        python2 get-pip.py --user
    else
        echo_error Python not installed!
        exit 1
    fi

    rm get-pip.py

    echo_install_info virtualenvwrapper
    pip install --user virtualenvwrapper
    echo_warn "Export WORKON_HOME and source virtualenvwrapper.sh!"
}

main $*
