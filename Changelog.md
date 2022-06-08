# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## unreleased
### Added
- App management file for [docker-compose](https://github.com/docker/compose) (v2)
- App management file for [ffsend](https://github.com/timvisee/ffsend)

## [v0.2.1.0] - 2022-01-22
### Added
- App management file for [xsv](https://github.com/BurntSushi/xsv)
- App management file for [Telegram](https://github.com/telegramdesktop/tdesktop)
- App management file for [Pandoc](https://github.com/jgm/pandoc)
- App management file for [wuzz](https://github.com/asciimoo/wuzz)
- App management file for [xh](https://github.com/ducaale/xh)
- App management file for [gitui](https://github.com/extrawurst/gitui)
- App management file for [ncdu](https://dev.yorhel.nl/ncdu)
- App management file for [dasel](https://github.com/TomWright/dasel)
- App management file for [git-trim](https://github.com/foriequal0/git-trim)
- App management file for [go](https://github.com/golang/go). Note that you should add `export GOROOT=~/.local/go; export GOPATH=~/.local/share/goprojects; export PATH=$GOPATH/bin:$GOROOT/bin:$PATH` or similar to your `~/.profile`
### Changed
- Use GitHub Actions for CI, see #15
### Fixed
- New download URL for `ncdu`, see #18
- Update bash completion file path for `fd`, see #18
- Support installation of `pip` on Python 3.5, see #18

## [v0.2.0.0] - 2020-07-31
### Added
- App management file for [gh](https://github.com/cli/cli)
- App management file for [jira](https://github.com/go-jira/jira)
- App management file for [delta](https://github.com/dandavison/delta)
- App management file for [qrcp](https://github.com/claudiodangelis/qrcp)
- App management file for [slack-term](https://github.com/erroneousboat/slack-term)
- App management file for [dust](https://github.com/bootandy/dust)
- The corresponding bash completion is installed with `fd`.
- The corresponding bash completion is installed with `ripgrep`.
- man pages are installed with `gh` (available since v0.9.0)
- Short forms for all provided options, see #11
- Bash and zsh completion scripts, see #13
### Changes
- Avoid using GitHub API calls, see #11
- `list` command without further option defaults to show installed packages, see #11
- Bash completion for apps is now installed into `~/.local/share/bash-completion/completions`, see #13
### Fixed
- Avoid false matching by part of package names, see #11
- Update download URL for shellcheck releases, see #14

## [v0.1.1.0] - 2020-03-14
### Added
- App management file for [shfmt](https://github.com/mvdan/sh)
- When installing shellcheck, the corresponding man page is installed if pandoc is available.
- When running install/upgrade/uninstall, a spinner is displayed to indicate background activity.
- `sdd` is more verbose about internal processes if the `SDD_VERBOSE` environment variable is set.
### Changed
- Specifying a version for installing or upgrading pip is possible.
- Upgrading oh-my-zsh now git-pulls in existing `$ZSH` repository.
- Any output from `sdd_*` management functions is redirected to a log file.
### Fixed
- Handle non-existing custom apps directory when listing available apps.

## [v0.1.0.0] - 2020-02-06
First release.
### Added
- Changelog file and related tooling.
