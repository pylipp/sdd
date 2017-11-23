#!/bin/bash

set -e

source $HOME/.files/setup/utils.bash

install_vim() {
    mkcswdir
    method=${1:-global}

    echo_install_info vim
    if [[ ! -d vim ]]; then
        if [[ $method = "global" ]]; then
            sudo apt-get remove -y vim vim-runtime gvim vim-tiny vim-common
            install_packages libncurses5-dev \
                libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
                python3-dev shellcheck xdotool markdown

            build_vim
            sudo make install

            sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
            sudo update-alternatives --set editor /usr/bin/vim
            sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
            sudo update-alternatives --set vi /usr/bin/vim
        elif [[ $method = "local" ]]; then
            build_vim

            mkcdir $HOME/.local/bin
            mv_existing vim
            ln -s $HOME/software/vim/src/vim vim
        else
            echo_error "Unknown method '$method'!"
            exit 1
        fi

        setup_vim_config
    fi
}

build_vim() {
    mkcswdir

    git clone https://github.com/vim/vim.git
    cd vim

    VIM_PYTHON2_CONFIG_DIR=/usr/lib/python2.7/config-x86_64-linux-gnu
    VIM_PYTHON3_CONFIG_DIR=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu
    while [[ ! -e $VIM_PYTHON2_CONFIG_DIR ]]; do
        echo -n "Path to Python2 config dir: "
        read VIM_PYTHON2_CONFIG_DIR
    done
    while [[ ! -e $VIM_PYTHON3_CONFIG_DIR ]]; do
        echo -n "Path to Python3 config dir: "
        read VIM_PYTHON3_CONFIG_DIR
    done

    ./configure --with-features=huge \
        --enable-multibyte \
        --enable-pythoninterp \
        --with-python-config-dir=$VIM_PYTHON2_CONFIG_DIR \
        --enable-python3interp \
        --with-python3-config-dir=$VIM_PYTHON3_CONFIG_DIR \
        --enable-cscope \
        --prefix=/usr

    make
}

setup_vim_config() {
    mv_existing $HOME/.vim
    ln -s $HOME/.files/vim $HOME/.vim

    mv_existing $HOME/.vimrc
    bash $HOME/.files/generate_vimrc.sh
    vim +qall < /dev/tty
    vim +PlugInstall +qall < /dev/tty

    # install linter
    pip install --user vim-vint

    if [[ -d "$HOME/.vim/bundle/YouCompleteMe" ]]; then
        echo_install_info YouCompleteMe
        cd $HOME/.vim/bundle/YouCompleteMe
        ./install.py --clang-completer
    fi
}
