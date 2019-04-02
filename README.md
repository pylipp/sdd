# `setup-da-distro`

> A generic installation framework to install binaries from web sources for non-root users on linux systems

- written in bash

## Requirements

- functionality to install, uninstall and update programs that are not provided by distribution packages via a high-level API
- local installation (i.e. not requiring super-user privileges) by default
- cross-distribution installation
- pre- and post-installation steps
- minimum dependencies for installation
- enable reproducible installations (by freezing versions)
- test in Docker container
- provide generic utility methods (generating symlinks, etc.)

## Synopsis

    PROGRAMNAME COMMAND OPTION

### Program name

- `sdd` (setup da distro)

### Command

- install
- update
- remove / uninstall

### Option

- help option
