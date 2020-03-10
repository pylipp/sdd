# `setup-da-distro`

[![Build Status](https://travis-ci.org/pylipp/sdd.svg?branch=master)](https://travis-ci.org/pylipp/sdd)

> A framework to manage installation of programs from web sources for non-root users on Linux systems
## Motivation

During occasional strolls on reddit or github, my attention is often drawn towards programs that increase productivity or provide an enhancement over others. (As a somewhat irrelevant side note - these programs mostly work in the command line.) Usually these programs are available for download as binary or script, meaning that naturally, the management (installation, upgrade, removal) of those programs has to be performed manually. At this point `sdd` comes into play: It provides a framework to automatize the tasks of managing the programs (or, in `sdd` terminology, 'apps'). The procedures to manage specific apps are defined within scripts in this repository (at `lib/sdd/apps/user/`).

`sdd` enables me to keep track of my favorite programs, on different machines. I'm working towards having systems set up in a reproducible way on my machines. `sdd` helps me, since I might have different Linux distributions installed on these machine, with different package manager providing different versions of required programs (or none at all). I can freeze the versions of all apps managed by sdd with `sdd list --installed > sdd_freeze.txt`, and re-create them with `sdd install <(cat sdd_freeze.txt | xargs)`.

## WARNINGS

`sdd` is a simple collection of bash scripts, not a mature package manager (neither do I aim to turn it into one...). Using it might break things on your system (e.g. overwrite existing program files).

When using `sdd`, you execute functionality to manipulate your system. Especially, you download programs from third parties, and install them on your system. Most sources are provided by GitHub releases pages. Keep in mind that repositories can be compromised, and malicious code placed inside; and `sdd` will still happily download it. (If you have an idea how to mitigate this security flaw, please open an issue.)

`sdd` is targeted to 64bit Linux systems. Some apps might not work when installed to different architectures. If available, `bash` and/or `zsh` shell completion and `man` pages are set up when installing an app.

## Demo

The following screencast demonstrates how `sdd` is used to install and uninstalled the [`fd`](https://github.com/sharkdp/fd) utility.

![Demo](./demo.svg)

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

`sdd` is tested with `bash` 4.4.12.

## Upgrading

Once the program is bootstrapped, upgrade to the latest version (GitHub master) by

    sdd upgrade sdd

## Usage

### Installing an app

Install an app to `SDD_INSTALL_PREFIX` (defaults to `~/.local`) with

    sdd install <app>

You can specify a custom installation prefix like this:

    SDD_INSTALL_PREFIX=~/bin sdd install <app>

or by exporting the `SDD_INSTALL_PREFIX` environment variable.

By default, `sdd` installs the latest version of the app available. You can specify a version for installation:

    sdd install <app>=<version>

> This command overwrites an existing installation of the app without additional conformation.

> The format of the `<version>` specifier depends on the app that is managed (usually it's the tag of the release on GitHub).

### Upgrading an app

To upgrade an app to the latest version available, run

    sdd upgrade <app>

If you want to upgrade to a specific version, run

    sdd upgrade <app>=<version>

Internally, `sdd` executes un- and re-installation of the app for upgrading unless a specific upgrade routine has been defined.
The usage of `SDD_INSTALL_PREFIX` is the same as for the `install` command.

### Uninstalling an app

To uninstall an app, run

    sdd uninstall <app>

The usage of `SDD_INSTALL_PREFIX` is the same as for the `install` command.

### Batch commands

The commands `install`, `upgrade`, and `uninstall` can take multiple arguments to manage apps, e.g.

    sdd install <app1> <app2>=<version> <app3>

### Listing app management information

List installed apps by running

    sdd list --installed

List all apps available for management in `sdd` with

    sdd list --available

List all installed apps that can be upgraded to a more recent version with

    sdd list --upgradable

### General help

High-level program output during management is forwarded to the terminal. Output of the `sdd_*` functions of the app management file is in `/tmp/sdd-<command>-<app>.stderr`.

You can always consult

    sdd --help

## Apps available

In alphabetical order:

Name | Description
:--- | :---
[bat](https://github.com/sharkdp/bat) | A cat(1) clone with syntax highlighting and Git integration
[broot](https://github.com/Canop/broot) | A new way to see and navigate directory trees
[diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) | Human readable diffs
[direnv](https://github.com/direnv/direnv) | Handle environment variables depending on current directory
[fd](https://github.com/sharkdp/fd) | A simple, fast and user-friendly alternative to 'find'
[hub](https://github.com/github/hub) | Command line tool to interact with GitHub
[jq](https://github.com/stedolan/jq) | Command line JSON processor
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) | Framework for managing zsh configuration
[pip](https://pypi.org/project/pip/) | Python package manager
[ripgrep](https://github.com/BurntSushi/ripgrep) | Line-oriented text search tool
sdd | Thanks for being here :)
[ShellCheck](https://github.com/koalaman/shellcheck) | A static analysis tool for shell scripts
[shfmt](https://github.com/mvdan/sh) | A shell parser, formatter, and interpreter (sh/bash/mksh)

## Customization

You can both

- define app management files for apps that are not shipped with `sdd`, and
- extend app management files for apps that are shipped with `sdd`.

The procedure in either case is:

1. Create an empty bash file named after the app in `~/.config/sdd/apps` (without `.bash` extension).
1. Add the functions `sdd_install` and `sdd_uninstall` with respective functionality. It's mandatory to add a function, even if without functionality (define `sdd_uninstall() { return; }`).
1. Optionally, you can add an `sdd_upgrade` function. It will be executed for upgrading, instead of `sdd_uninstall` followed by `sdd_install`.
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
- `python3`
- optionally: `docker-compose`

### Development environment

Clone this repository and pull the Docker image to enable testing and style-checking.

    git clone https://github.com/pylipp/sdd
    docker pull pylipp/sdd

Set up the local environment for style-checking using the [pre-commit](https://pre-commit.com/) framework.

    test/setup/venv

### Testing

The program is tested in a container environment using the `bats` framework.

    test/run.sh

You might want to skip app tests since they require an internet connection

    NO_APP_TESTS=1 test/run.sh

For attaching to the test container after the tests have completed, do

    test/run.sh --debug

For creating a Docker container and attaching it to the terminal, do

    test/run.sh --open

For style checking, run

    test/run.sh --style

For building the image, run

    docker build test/setup -t sdd:latest

You can also build and test the image in a single command by

    docker-compose -f test/setup/docker-compose.test.yml up

Note that DockerHub automatically builds the image when source code is pushed to GitHub, and pushes it the DockerHub repository if the tests succeeded. The tests are defined in `test/setup/docker-compose.test.yml`.

### Extending

You're looking for managing an app but it's not included in `sdd` yet? Here's how contribute an app management script:

1. Fork this repository.
1. In your fork, create a feature branch.
1. Create an empty bash file named after the app in `lib/sdd/apps/user`.
1. Add a test in `test/apps/<app>.bats`, e.g. verifying the version of the app to be installed.
1. Add the functions `sdd_install` and `sdd_uninstall` with respective functionality.
1. Add app name, link, and description to the table of available apps in the README file.
1. Add the new files, commit, and push.
1. Open a PR!

### Releasing

1. Update Changelog.
1. Run `./release VERSION`

## Python apps

Consider using [`pipx`](https://pipxproject.github.io/pipx/) for installing Python applications (in isolated environments).
