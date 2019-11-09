# `setup-da-distro`

[![Build Status](https://travis-ci.org/pylipp/sdd.svg?branch=master)](https://travis-ci.org/pylipp/sdd)

> A framework to manage installation of apps from web sources for non-root users on Linux systems

## Installation

Clone the directory and run the bootstrap script to install `sdd` to `~/.local`:

    git clone https://github.com/pylipp/sdd
    cd sdd
    ./bootstrap.sh

You can specify the installation directory with the `PREFIX` environment variable:

    PREFIX=/usr ./bootstrap.sh

Please verify that the `bin` sub-directory of the installation directory is present in your `PATH`. You might want to append this to your shell configuration file:

    export PATH="~/.local/bin:$PATH"

Same applies for the `MANPATH`:

    export MANPATH="~/.local/share/man:$MANPATH"

For enabling `zsh` completion functions (`oh-my-zsh` users: put this before the line that sources `oh-my-zsh.sh` since it calls `compinit` for setting up completions):
    
    fpath=(~/.local/share/zsh/site-functions $fpath)

## Upgrading

Once the program is bootstrapped, upgrade to the latest version (GitHub master) by

    sdd install sdd

## Usage

Install an app to `SDD_INSTALL_PREFIX` (defaults to `~/.local`) with

    sdd install <app>

You can specify a custom installation prefix like this:

    SDD_INSTALL_PREFIX=~/bin sdd install <app>

or by exporting the `SDD_INSTALL_PREFIX` environment variable.

By default, `sdd` installs the latest version of the app available. You can specify a version for installation:

    sdd install <app>=<version>

To upgrade an app, run

    sdd upgrade <app>

To uninstall an app, run

    sdd uninstall <app>

The usage of `SDD_INSTALL_PREFIX` is the same as for the `install` command.

List installed apps by running

    sdd list --installed

List all apps available for management in `sdd` with

    sdd list --available

`sdd` is verbose. Any program output during management is forwarded to the terminal, and to respective `stdout`/`stderr` log files in `/tmp`.

You can always consult

    sdd --help

## Customization

You can both

- define app management files for apps that are not shipped with `sdd`, and
- extend app management files for apps that are shipped with `sdd`.

The procedure in either case is:

1. Create an empty bash file named after the app in `~/.config/sdd/apps` (without `.bash` extension).
1. Add the functions `sdd_install` and/or `sdd_uninstall` with respective functionality.
1. You're able to manage the app as described in the 'Usage' section. `sdd` tells you when it found a customization for the app specified on the command line.

For exemplary files, see my personal definitions and extensions [here](https://github.com/pylipp/dotfiles/tree/master/sdd_apps).

## Project structure

It is distinguished between

- framework files,
- app management files,
- testing files, and
- project meta-files.

### Description

1. Framework files contain the logic to run the program. They provide generic utility methods (generating symlinks, reading environment variables, etc.). Examples are: program executable, library files.
1. App management files contain instructions to manage specific apps. For each app, at least one management file exists. A management file contains at least methods for installing, upgrading, and uninstalling an app. Management files are organized in directories indicating their level (user or root).
1. Testing files cover the functionality of both the framework and the app management files. They are executed in an isolated environment.
1. Project meta-files comprise documentation files, configuration files for development tools, an installation script, among others.

## Contributing

### Requirements

- `git`
- `docker`

### Testing

The program is tested in a container environment using the `bats` framework.
Clone this repository and pull the Docker image to run tests.

    git clone https://github.com/pylipp/sdd
    docker pull pylipp/sdd
    cd sdd
    test/run.sh
    # For skipping tests of apps
    NO_APP_TESTS=1 test/run.sh
    # For attaching to the test container after the tests have completed
    test/run.sh --debug

For building the image, run

    docker build test/setup -t sdd:latest

### Extending

You're looking for managing an app but it's not included in `sdd` yet? Here's how contribute an app management script:

1. Fork this repository.
1. In your fork, create a feature branch.
1. Create an empty bash file named after the app in `lib/sdd/apps/user`.
1. Add a test in `test/apps/<app>.bats`, e.g. verifying the version of the app to be installed.
1. Add three functions `sdd_install`, `sdd_upgrade`, `sdd_uninstall` with respective functionality.
1. Add the new files, commit, and push.
1. Open a PR!

## Python apps

Consider using [`pipx`](https://pipxproject.github.io/pipx/) for installing Python applications (in isolated environments).
