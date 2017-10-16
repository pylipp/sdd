#! /bin/bash

# https://www.dropbox.com/install-linux
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# link machine to Dropbox account, kill with Ctrl-C afterwards
~/.dropbox-dist/dropboxd

# set up command line utility
wget -O ~/.local/bin/dropbox https://www.dropbox.com/download?dl=packages/dropbox.py
chmod 755 ~/.local/bin/dropbox
