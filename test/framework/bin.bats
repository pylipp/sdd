validappfilepath=../lib/sdd/apps/user/valid_app

teardown() {
  rm -f "$validappfilepath"
  rm -f ${SDD_INSTALL_PREFIX:-$HOME/.local}/bin/valid_app
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

@test "invoking install command with invalid app fails" {
  run sdd install invalid_app
  [ "$status" -eq 2 ]
  [ "$output" = 'App "invalid_app" could not be found.' ]
}

@test "invoking install command with valid app but without sdd_install present fails" {
  touch $validappfilepath

  run sdd install valid_app
  [ "$status" -eq 4 ]
  [[ "$output" = 'Error installing "valid_app": '* ]]
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
}

@test "invoking uninstall command without argument fails" {
  run sdd uninstall
  [ "$status" -eq 1 ]
  [ "$output" = 'Specify at least one app to uninstall.' ]
}

@test "invoking uninstall command with invalid app fails" {
  run sdd uninstall invalid_app
  [ "$status" -eq 2 ]
  [ "$output" = 'App "invalid_app" could not be found.' ]
}

@test "invoking uninstall command with valid app but without sdd_uninstall present fails" {
  touch $validappfilepath

  run sdd uninstall valid_app
  [ "$status" -eq 4 ]
  [[ "$output" = 'Error uninstalling "valid_app": '* ]]
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