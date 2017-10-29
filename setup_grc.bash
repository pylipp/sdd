#! /bin/bash

source ~/.files/setup/utils.bash

mkcswdir

wget https://raw.githubusercontent.com/garabik/grc/master/debian/changelog
VERSION=$(head -n1 changelog | cut -d" " -f2 | tr -d \(\))
DEBPACKAGE=grc_$VERSION\_all.deb
wget http://korpus.juls.savba.sk/~garabik/software/grc/$DEBPACKAGE

sudo dpgk --install $DEBPACKAGE
rm -rf changelog $DEBPACKAGE

ln -s ~/.files/grc ~/.grc
