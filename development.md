It is attempted to derive the development of `sdd` according to requirements and specifications.

### Program

Requirement | Specification
--- | ---
The program shall run on Linux systems. | The program can be executed in a Docker container.
The program shall have as little dependencies as possible. | The program depends on `bash`, `git` and `wget`. Python-related apps require `python3`.
The program shall be simple to install. | A bootstrap installation script is provided.
The program shall be simple to update. | The program is able to update itself.
The program shall expose a user-friendly command line interface. | The program complies to standards given by common command line tools.
The program shall provide functionality to manage apps that are not made available by distribution package managers. The fundamental functionality comprises installation, removal, and updating. Management includes the app's binary (i.e. main executable), runtime files (e.g. library files), and convenience (e.g. shell completion or man pages) files. | The program provides an `install` command to install one or more apps and a `uninstall` command to uninstall one or more apps.
The program shall allow `user`s (i.e. without requiring super-user privileges) to manage apps. | The program manages apps in the user's home directory in subdirectories of `~/.local`.
The program shall optionally allow `root` to manage apps. |
The program shall optionally allow for 'hybrid' (user and root) management. |
The program shall allow for custom management that extends or overwrites the built-in management. | The program takes custom app management files in the `~/.config/sdd/apps` directory into account for additional management instructions.
The program shall inform about optional dependencies required during app installation. |
The program shall install the latest released version of an app if not specified otherwise. | The program is able to find the latest version of an app online.
The program shall take user-defined app versions into account for installation. | The program takes into account an app version specified in the CLI when installing. This takes precedence of an app version specified in the program configuration.
The program shall keep track of installed apps. | The program holds a record of installed apps.
The program shall enable reproducible app installations. | The record of installed apps can be queried, and e.g. be redirected to a file.
The program shall update an app only if the specified version is not yet installed. |
The program shall install app dependencies using the distribution package manager if unavoidable. |
The program shall provide useful output when a command fails. | The program validates user input early and verifies app management files.
The program shall be configurable. |
The program shall provide functionality to list installed apps. | The program provides a `list` command with the option `--installed`.
The program shall provide functionality to list available apps. | The program provides a `list` command with the option `--available`.
The program shall provide functionality to manage system configuration (e.g. enabling automatic mounting of USB devices). |
The program shall optionally output information about internal procedures. | The program provides a `--verbose` option.

### Development

The program shall be extensively tested using state-of-the-art tools (CI, containers, test libraries).
The apps available for installation via the program shall be extensible by community contributions.
The program shall be developed using modern methods (linter, formatter) if not obstructive.

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
