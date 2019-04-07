# `setup-da-distro`

> A framework to manage installation of apps from web sources for non-root users on Linux systems

## Installation

Clone the directory and run the installer to install `sdd` to `~/.local`:

    git clone https://github.com/pylipp/sdd
    cd sdd
    ./install.sh

You can specify the installation directory with the `PREFIX` environment variable:

    PREFIX=/usr ./install.sh

Please verify that the `bin` sub-directory of the installation directory is present in your `PATH`. You might want to append this to your shell configuration file:

    export PATH="~/.local/bin:$PATH"

## Usage

Install an app to `SDD_INSTALL_PREFIX` (defaults to `~/.local`) with

    sdd install <app>

You can specify a custom installation prefix like this:

    SDD_INSTALL_PREFIX=~/bin sdd install <app>

or by exporting the `SDD_INSTALL_PREFIX` environment variable.

## Requirements

### Prioritized

1. The program shall run on Linux systems.
1. The program shall have as little dependencies as possible.
1. The program shall be simple to install.
1. The program shall expose a command line interface.
1. The program shall provide functionality to manage apps that are not made available by distribution package managers. The fundamental functionality comprises
    1. installation,
    1. removal, and
    1. updating.

    Management includes the app's binary (i.e. main executable), runtime files (e.g. library files), and convenience (e.g. shell completion or man pages) files.

1. The program shall allow `user`s (i.e. without requiring super-user privileges) to manage apps.
1. The program shall optionally allow `root` to manage apps.
1. The program shall optionally allow for 'hybrid' (user and root) management.
1. The program shall inform about optional dependencies required during app installation.
1. The program shall install the latest released version of an app if available.
1. The program shall take user-defined app versions into account for installation.
1. The program shall enable reproducible app installations by freezing version numbers of installed apps.

### Development

1. The program shall be extensively tested using state-of-the-art tools (CI, containers, test libraries).
1. The apps available for installation via the program shall be extensible by community contributions.
1. The program shall be developed using modern methods (linter, formatter) if not obstructive.

### Optional

1. The program shall install app dependencies using the distribution package manager if unavoidable.
1. The program shall check for the availability of new app versions.
1. The program shall provide useful output when a command fails.
1. The program shall be configurable.
1. The program shall provide functionality to list installed apps.
1. The program shall provide functionality to list available apps.
1. The program shall provide functionality to manage system configuration (e.g. enabling automatic mounting of USB devices).

## Project structure

It is distinguished between

- framework files,
- app management files,
- testing files, and
- project meta-files.

### Description

1. Framework files contain the logic to run the program. They provide generic utility methods (generating symlinks, reading environment variables, etc.). Examples are: program executable, library files.
1. App management files contain instructions to manage specific apps. For each app, at least one management file exists. A management file contains at least methods for installing, updating, and removing an app. Management files are organized in directories indicating their level (user or root).
1. Testing files cover the functionality of both the framework and the app management files. They are executed in an isolated environment.
1. Project meta-files comprise documentation files, configuration files for development tools, an installation script, among others.

## Specification

- R1: The program can be executed in a Docker container.

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
1. Add three functions `sdd_install`, `sdd_update`, `sdd_remove` with respective functionality.
1. Add the new files, commit, and push.
1. Open a PR!

## Synopsis

    PROGRAMNAME COMMAND OPTION

### Program name

- `sdd` (setup da distro)

### Commands

- `install`
- `update`
- `remove` / `uninstall`

### Options

- `--help`

#### With command

- `--root`
