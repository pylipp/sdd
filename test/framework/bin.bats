validappfilepath=../lib/sdd/apps/user/valid_app
validcustomappfilepath=$HOME/.config/sdd/apps/valid_app
invalidappfilepath=../lib/sdd/apps/user/invalid_app
appsrecordfilepath=$HOME/.local/share/sdd/apps/installed

teardown() {
  rm -f "$validappfilepath"
  rm -f "$invalidappfilepath"
  rm -f ${SDD_INSTALL_PREFIX:-$HOME/.local}/bin/valid_app
  rm -f "$appsrecordfilepath"
  rm -rf $HOME/.config/sdd
}

@test "invoking main executable prints usage" {
  run sdd
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Usage: sdd [OPTIONS] COMMAND [APP [APP...]]" ]
}

@test "invoking unknown command fails" {
  run sdd unknown-command
  [ "$status" -eq 127 ]
  [ "$output" = 'Unknown command "unknown-command"' ]
}

@test "invoking help option prints usage" {
  run sdd --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Usage: sdd [OPTIONS] COMMAND [APP [APP...]]" ]
}

@test "invoking install command without argument fails" {
  run sdd install
  [ "$status" -eq 1 ]
  [ "$output" = 'Specify at least one app to install.' ]
}

@test "invoking install command with non-existing app fails" {
  run sdd install non_existing_app
  [ "$status" -eq 2 ]
  [ "$output" = 'App "non_existing_app" could not be found.' ]
}

@test "invoking install command with existing app but without sdd_install present fails" {
  touch $invalidappfilepath

  run sdd install invalid_app
  [ "$status" -eq 4 ]
  [[ "$output" = 'Error installing "invalid_app": '* ]]
  [[ "$output" = *'sdd_install: command not found' ]]
}

@test "invoking install command with valid app succeeds" {
  # Create app management file for 'valid_app' containing an sdd_install
  # function that creates an executable 'valid_app'
  cp framework/fixtures/valid_app $validappfilepath

  run sdd install valid_app
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 'Latest version available: 1.0' ]
  [ "${lines[1]}" = 'Installed "valid_app".' ]

  # Execute the app
  run valid_app
  [ "$status" -eq 0 ]

  # The installed app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.0" ]
}

@test "invoking install command with valid custom app succeeds" {
  # Create app management file for 'valid_app' containing an sdd_install
  # function that creates an executable 'valid_app'
  mkdir -p $(dirname $validcustomappfilepath)
  cp framework/fixtures/valid_app $validcustomappfilepath

  run sdd install valid_app
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 'Latest version available: 1.0' ]
  [ "${lines[1]}" = 'Installed "valid_app".' ]

  # Execute the app
  run valid_app
  [ "$status" -eq 0 ]

  # The installed app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.0" ]
}

@test "invoking install command with valid and non-existing app installs only valid one" {
  cp framework/fixtures/valid_app $validappfilepath

  run sdd install valid_app non_existing_app
  [ "$status" -eq 2 ]
  [ "${lines[0]}" = 'App "non_existing_app" could not be found.' ]

  run valid_app
  [ "$status" -eq 0 ]

  run which invalid_app
  [ "$status" -eq 1 ]
}

@test "invoking install command with valid and invalid app installs only valid one" {
  cp framework/fixtures/valid_app $validappfilepath
  touch $invalidappfilepath

  run sdd install valid_app invalid_app
  [ "$status" -eq 4 ]
  [ "${lines[0]}" = 'Latest version available: 1.0' ]
  [ "${lines[1]}" = 'Installed "valid_app".' ]
  [[ "${lines[2]}" = 'Error installing "invalid_app": '* ]]
  [[ "${lines[2]}" = *'sdd_install: command not found' ]]

  run valid_app
  [ "$status" -eq 0 ]

  run which invalid_app
  [ "$status" -eq 1 ]
}

@test "invoking install command with valid custom and non-existing app installs only custom one" {
  mkdir -p $(dirname $validcustomappfilepath)
  cp framework/fixtures/valid_app $validcustomappfilepath

  run sdd install valid_app non_existing_app
  [ "$status" -eq 2 ]
  [ "${lines[0]}" = 'App "non_existing_app" could not be found.' ]
  [ "${lines[1]}" = 'Latest version available: 1.0' ]
  [ "${lines[2]}" = 'Installed "valid_app".' ]

  run valid_app
  [ "$status" -eq 0 ]

  run which non_existing_app
  [ "$status" -eq 1 ]
}

@test "invoking install command with valid app and version succeeds" {
  cp framework/fixtures/valid_app $validappfilepath

  run sdd install valid_app=1.1
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 'Specified version: 1.1' ]
  [ "${lines[1]}" = 'Installed "valid_app".' ]

  # The installed app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.1" ]
}

@test "invoking uninstall command without argument fails" {
  run sdd uninstall
  [ "$status" -eq 1 ]
  [ "$output" = 'Specify at least one app to uninstall.' ]
}

@test "invoking uninstall command with non-existing app fails" {
  run sdd uninstall non_existing_app
  [ "$status" -eq 2 ]
  [ "$output" = 'App "non_existing_app" could not be found.' ]
}

@test "invoking uninstall command with existing app but without sdd_uninstall present fails" {
  touch $invalidappfilepath

  run sdd uninstall invalid_app
  [ "$status" -eq 4 ]
  [[ "$output" = 'Error uninstalling "invalid_app": '* ]]
  [[ "$output" = *'sdd_uninstall: command not found' ]]
}

@test "invoking uninstall command with valid app succeeds" {
  # Create app management file for 'valid_app' containing an sdd_uninstall
  # function that uninstalls the executable 'valid_app'
  cp framework/fixtures/valid_app $validappfilepath

  # Install 'valid_app'
  sdd install valid_app
  run valid_app
  [ "$status" -eq 0 ]

  run sdd uninstall valid_app
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 'Uninstalled "valid_app".' ]

  run which valid_app
  [ "$status" -eq 1 ]
}

@test "invoking list with --installed option displays installed apps including versions" {
  cp framework/fixtures/valid_app $validappfilepath
  sdd install valid_app

  run sdd list --installed
  [ $status -eq 0 ]
  [ "${lines[0]}" = "valid_app=1.0" ]

  # Bump version number
  sed -i 's/1.0/1.1/' $validappfilepath
  sdd install valid_app

  run sdd list --installed
  [ $status -eq 0 ]
  [ "${lines[0]}" = "valid_app=1.1" ]

  sdd uninstall valid_app
  run sdd list --installed
  [ $status -eq 0 ]
  [ "$output" = "" ]
}

@test "invoking list with --available option displays available apps" {
  cp framework/fixtures/valid_app $validappfilepath

  run sdd list --available
  [ $status -eq 0 ]

  run grep -q valid_app <<<"$output"
  [ $status -eq 0 ]
}
