#! /bin/bash

# https://st.suckless.org/ simple terminal

# toggle light/dark theme by F6
# zoom in/out via Ctrl-Shift-PageUp/Down
# copy/paste via Ctrl-Shift-C/V

source $(dirname "$0")/utils.bash

echo_install_info simple-terminal
mkcswdir

install_packages libxft-dev

# clone source and checkout revision that matches the patches
git clone git://git.suckless.org/st
cd st || ( echo "Error cloning..."; exit )
git checkout b331da5

# apply patches for solarized color scheme and custom font/fontsize
wget https://st.suckless.org/patches/solarized/st-no_bold_colors-20170623-b331da5.diff
wget https://st.suckless.org/patches/solarized/st-solarized-both-20170626-b331da5.diff
wget https://st.suckless.org/patches/clipboard/st-clipboard-20170925-b1338e9.diff
patch < "$HOME"/.files/setup/st-custom-font-20170928-b331da5.diff
patch < st-no_bold_colors-20170623-b331da5.diff
patch < st-solarized-both-20170626-b331da5.diff
patch < st-clipboard-20170925-b1338e9.diff

sudo make clean install
