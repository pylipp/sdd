#!/bin/bash

source "$HOME"/.files/setup/utils.bash

mkcswdir

install_packages python3-pyqt5 python3-pyqt5.qtwebkit python3-pyqt5.qtquick python-tox \
    python3-sip python3-dev python3-pyqt5.qtsql libqt5sql5-sqlite
git clone https://github.com/qutebrowser/qutebrowser

cd qutebrowser
tox -v -e mkvenv-pypi
cd ..

# generate docs
install_packages asciidoc source-highlight
git clone https://github.com/asciidoc/asciidoc
cd qutebrowser/scripts
./asciidoc2html.py --asciidoc python2 ~/software/asciidoc/asciidoc.py

# TODO: set links in individual installation files or in single script?
setup_xdg_config_link qutebrowser qutebrowser_config.py config.py
