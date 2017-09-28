#!/bin/bash

source "$HOME"/.files/setup/utils.bash

mkcswdir

install_packages python3-lxml python3-pyqt5 \
    python3-pyqt5.qtwebkit python3-pyqt5.qtquick python3-sip python3-jinja2 \
    python3-pygments python3-yaml python3-pyqt5.qtsql libqt5sql5-sqlite \
    python3-pyqt5.qtwebengine python3-pyqt5.qtopengl

git clone https://github.com/qutebrowser/qutebrowser
cd qutebrowser

pip3 install --user .
# QT_XCB_FORCE_SOFTWARE_OPENGL=1 qutebrowser --backend webengine index.html
