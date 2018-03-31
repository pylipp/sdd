#!/bin/bash

set -e

source $(dirname "$0")/utils.bash

mkcswdir

install_packages python3-pyqt5 python3-pyqt5.qtwebkit python3-pyqt5.qtquick python-tox \
    python3-sip python3-dev python3-pyqt5.qtsql libqt5sql5-sqlite
git clone https://github.com/qutebrowser/qutebrowser

cd qutebrowser
git checkout v1.2.0
tox -v -e mkvenv-pypi

# updating via
#tox -r -e mkvenv-pypi

# generate docs
# https://qutebrowser.org/INSTALL.html#_additional_hints
sudo apt install -y --no-install-recommends asciidoc source-highlight
python3 scripts/asciidoc2html.py

# TODO: set links in individual installation files or in single script?
setup_xdg_config_link qutebrowser qutebrowser_config.py config.py

# make x-www-browser call qutebrowser
sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser $HOME/.files/bin/qutebrowser 200
update-alternatives --config x-www-browser

# to make thunderbird open links in qutebrowser, edit ~/.thunderbird/<profile>.default/prefs.js
# the network.protocol-handler.warn-external.* entries require the value 'true'
# also delete ~/.thunderbird/<profile>.default/mimeTypes.rdf
# then thunderbird asks for a new default application to open links etc.
# see also: http://kb.mozillazine.org/Setting_Your_Default_Browser#Setting_the_browser_that_opens_in_Thunderbird_-_Linux
