#!/usr/bin/env bash

set -e

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

prefix=${PREFIX:-~/.local}

for dep in wget bash; do
    if ! command -v $dep >/dev/null 2>&1; then
        echo "Could not find $dep." >&2
        exit 1
    fi
done

mkdir -p "$prefix"/{bin,lib}

cp "$SCRIPTDIR"/bin/sdd "$prefix"/bin
cp -r "$SCRIPTDIR"/lib/sdd "$prefix"/lib

if [[ ! "$PATH" == *"$prefix/bin"* ]]; then
    export PATH="$prefix/bin:$PATH"
fi

# Install shell completions, compatible to bash-completion
# https://github.com/scop/bash-completion/blob/328ce5be5b4b8822b3b9421dab4460c56990df0b/bash_completion#L2159
SDD_BASH_COMPLETION_DIR=${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$prefix/share}/bash-completion}/completions
SDD_ZSH_COMPLETION_DIR="${XDG_DATA_HOME:-$prefix/share}"/zsh/site-functions
mkdir -p "$SDD_BASH_COMPLETION_DIR" "$SDD_ZSH_COMPLETION_DIR"
cp "$SCRIPTDIR"/completion/sdd "$SDD_BASH_COMPLETION_DIR"
cp "$SCRIPTDIR"/completion/_sdd "$SDD_ZSH_COMPLETION_DIR"

# Record installed version
if ! latest_tag="$(git tag --list --sort -refname | grep -m1 -E 'v0.[0-9]+.[0-9]+.[0-9]+')"; then
    echo "Failed to find latest tag!" >&2
    exit 1
fi

head_sha="$(git rev-parse HEAD)"
if [[ "$(git rev-parse "$latest_tag")" != "$head_sha" ]]; then
    # construct version identifier of form 'v0.X.Y.Z (+N @d34dc0ffee)'
    nr_commits_since_latest_tag="$(git rev-list "$latest_tag".. --count)"
    latest_tag="$latest_tag (+$nr_commits_since_latest_tag @$head_sha)"
fi

echo "$latest_tag" > "$prefix"/lib/sdd/version

SDD_APPS_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/sdd/apps
mkdir -p "$SDD_APPS_DIR"
echo sdd="$head_sha" >> "$SDD_APPS_DIR"/installed
