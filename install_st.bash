#! /bin/bash

# https://st.suckless.org/ simple terminal

# toggle light/dark theme by F6
# zoom in/out via Ctrl-Shift-PageUp/Down
# copy/paste via Ctrl-Shift-C/V

set -e

source $(dirname "$0")/utils.bash

echo_install_info simple-terminal
mkcswdir

install_packages libxft-dev

# Clone source and checkout revision that matches the patches
git clone git://git.suckless.org/st
cd st || ( echo "Error cloning..."; exit )
git checkout 0.8.1

# Download patches for solarized color scheme and clipboard behaviour
wget https://st.suckless.org/patches/solarized/st-no_bold_colors-0.8.1.diff
wget https://st.suckless.org/patches/solarized/st-solarized-both-0.8.1.diff
wget https://st.suckless.org/patches/clipboard/st-clipboard-0.8.1.diff

# Apply patches
patch < "$HOME"/.files/setup/st-custom-font-0.8.1.diff
patch < st-no_bold_colors-0.8.1.diff
patch < st-solarized-both-0.8.1.diff
patch < st-clipboard-0.8.1.diff

sudo make clean install
