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

# make x-www-browser call qutebrowser
sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser $HOME/.files/bin/qutebrowser 200
update-alternatives --config x-www-browser

# to make thunderbird open links in qutebrowser, edit ~/.thunderbird/<profile>.default/prefs.js
# the network.protocol-handler.warn-external.* entries require the value 'true'
# also delete ~/.thunderbird/<profile>.default/mimeTypes.rdf
# then thunderbird asks for a new default application to open links etc.
# see also: http://kb.mozillazine.org/Setting_Your_Default_Browser#Setting_the_browser_that_opens_in_Thunderbird_-_Linux
xdg-mime default qutebrowser.desktop text/html
