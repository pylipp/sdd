#!/usr/bin/env bash

set -e

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

prefix=${PREFIX:-~/.local}

mkdir -p "$prefix"/{bin,lib}

cp "$SCRIPTDIR"/bin/sdd "$prefix"/bin
cp -r "$SCRIPTDIR"/lib/sdd "$prefix"/lib

if [[ ! "$PATH" == *"$PREFIX/bin"* ]]; then
    export PATH="$PREFIX/bin:$PATH"
fi

# Record installed version
SDD_APPS_DIR=${XDG_DATA_DIR:-$HOME/.local/share}/sdd/apps
mkdir -p "$SDD_APPS_DIR"
echo sdd="$(git rev-parse HEAD)" >> "$SDD_APPS_DIR"/installed
