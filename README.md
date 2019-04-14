# `setup-da-distro`

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

## Updating

Once the program is bootstrapped, update to the latest version (GitHub master) by

    sdd install sdd

## Usage

Install an app to `SDD_INSTALL_PREFIX` (defaults to `~/.local`) with

    sdd install <app>

You can specify a custom installation prefix like this:

    SDD_INSTALL_PREFIX=~/bin sdd install <app>

or by exporting the `SDD_INSTALL_PREFIX` environment variable.

By default, `sdd` installs the latest version of the app available. You can specify a version for installation:

    sdd install <app>=<version>

To uninstall an app, run

    sdd uninstall <app>

The usage of `SDD_INSTALL_PREFIX` is the same as for the `install` command.

List installed apps by running

    sdd list --installed

## Requirements

### Prioritized

1. The program shall run on Linux systems.
1. The program shall have as little dependencies as possible.
1. The program shall be simple to install.
1. The program shall be simple to update.
1. The program shall expose a user-friendly command line interface.
1. The program shall provide functionality to manage apps that are not made available by distribution package managers. The fundamental functionality comprises
    1. installation,
    1. removal, and
    1. updating.

    Management includes the app's binary (i.e. main executable), runtime files (e.g. library files), and convenience (e.g. shell completion or man pages) files.

1. The program shall allow `user`s (i.e. without requiring super-user privileges) to manage apps.
1. The program shall optionally allow `root` to manage apps.
1. The program shall optionally allow for 'hybrid' (user and root) management.
1. The program shall inform about optional dependencies required during app installation.
1. The program shall install the latest released version of an app if not specified otherwise.
1. The program shall take user-defined app versions into account for installation.
1. The program shall enable reproducible app installations.
1. The program shall keep track of installed apps.
1. The program shall update an app only if the specified version is not yet installed.

### Development

1. The program shall be extensively tested using state-of-the-art tools (CI, containers, test libraries).
1. The apps available for installation via the program shall be extensible by community contributions.
1. The program shall be developed using modern methods (linter, formatter) if not obstructive.

### Optional

1. The program shall install app dependencies using the distribution package manager if unavoidable.
1. The program shall provide useful output when a command fails.
1. The program shall be configurable.
1. The program shall provide functionality to list installed apps.
1. The program shall provide functionality to list available apps.
1. The program shall provide functionality to manage system configuration (e.g. enabling automatic mounting of USB devices).
1. The program shall optionally output information about internal procedures.

## Project structure

It is distinguished between

- framework files,
- app management files,
- testing files, and
- project meta-files.

### Description

1. Framework files contain the logic to run the program. They provide generic utility methods (generating symlinks, reading environment variables, etc.). Examples are: program executable, library files.
1. App management files contain instructions to manage specific apps. For each app, at least one management file exists. A management file contains at least methods for installing, updating, and uninstalling an app. Management files are organized in directories indicating their level (user or root).
1. Testing files cover the functionality of both the framework and the app management files. They are executed in an isolated environment.
1. Project meta-files comprise documentation files, configuration files for development tools, an installation script, among others.

## Specification

- R1: The program can be executed in a Docker container.
- R2: The program depends on:
    - `git`
    - `wget`
- R3: A bootstrap installation script is provided.
- R4: The program is able to update itself.
- R5: See R1.
- R6: The program provides an `install` command to install one or more apps and a `uninstall` command to uninstall one or more apps.
- R11: The program is able to find the latest version of an app online.
- R12: The program takes into account an app version specified in the CLI when installing. This takes precedence of an app version specified in the program configuration.
- R13: The program holds a record of installed apps.

### Optional

- R4 / R5: The program provides a `list` command with the options `--installed` and `--all`.
- R7: The program provides a `--verbose` option.

### Exemplary visualization

    .
    ├── bin
    │   └── program
    ├── installer
    ├── lib
    │   └── program
    │       ├── apps
    │       │   ├── root
    │       │   │   └── reqs
    │       │   └── user
    │       └── framework
    └── test
        ├── apps
        ├── framework
        └── setup

## Contributing

### Requirements

- `git`
- `docker`

### Testing

The program is tested in a container environment using the `bats` framework.
Clone this repository and build the Docker image to run tests.

    git clone https://github.com/pylipp/sdd
    cd sdd
    docker build test/setup -t sdd:latest
    test/run.sh

### Extending

You're looking for managing an app but it's not included in `sdd` yet? Here's how contribute an app management script:

1. Fork this repository.
1. In your fork, create a feature branch.
1. Create an empty bash file named after the app in `lib/sdd/apps/user`.
1. Add a test in `test/apps/<app>.bats`, e.g. verifying the version of the app to be installed.
1. Add three functions `sdd_install`, `sdd_update`, `sdd_uninstall` with respective functionality.
1. Add the new files, commit, and push.
1. Open a PR!

## Synopsis

    PROGRAMNAME COMMAND OPTION

### Program name

- `sdd` (setup da distro)

### Commands

- `install`
- `update`
- `uninstall`

### Options

- `--help`

#### With command

- `--root`
