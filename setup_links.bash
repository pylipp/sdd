#! /bin/bash

source ~/.files/setup/utils.bash

main() {
    echo_info "----------------------------------------------------------"
    echo_info "Setting up symbolic links to .files..."
    cd $HOME
    for rcfile in ycm_extra_conf.py gitconfig bashrc i3 \
        xinitrc dir_colors latexmkrc pylintrc tigrc direnvrc \
        pythonrc mailcap profile zprofile xprofile \
        vintrc.yaml
    do
        link_name="."$rcfile
        link_path=$HOME/$link_name
        mv_existing $link_path
        setup_link $rcfile $link_path
    done
    
    mkdir -p $HOME/.config/zathura
    ln -s $HOME/.files/zathurarc $HOME/.config/zathura/zathurarc
    mkdir -p $HOME/.ptpython 
    ln -s $HOME/.files/ptpython_config.py $HOME/.ptpython/config.py
    mkdir -p $HOME/.config/pudb
    ln -s $HOME/.files/pudb.cfg $HOME/.config/pudb/pudb.cfg
    mkdir -p $HOME/.config/feh
    ln -s $HOME/.files/feh $HOME/.config/feh
    mkdir -p $HOME/.local/share
    ln -s $HOME/.files/local/share/applications $HOME/.local/share/applications
    ln -s $HOME/.files/flake8rc $HOME/.config/flake8
}

main
