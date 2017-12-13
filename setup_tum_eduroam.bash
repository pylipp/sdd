#!/bin/bash

set -e

cd ~ || exit
wget https://www.lrz.de/services/netz/wlan/eduroam/eduroam-mwn-linux.sh

# tries some fallback installation if python-dbus not installed...
sudo apt-get install -y python-dbus

bash eduroam-mwn-linux.sh
rm -rf eduroam-mwn-linux.sh
