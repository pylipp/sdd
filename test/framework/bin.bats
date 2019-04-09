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
  local appfilepath=../lib/sdd/apps/user/valid_app
  touch $appfilepath

  run sdd install valid_app
  [ "$status" -eq 4 ]
  [[ "$output" = 'Error installing "valid_app": '* ]]
  [[ "$output" = *'sdd_install: command not found' ]]

  rm $appfilepath
  [ ! -f $appfilepath ]
}

@test "invoking install command with valid app succeeds" {
  # Create app management file for 'valid_app' containing an sdd_install
  # function that creates an executable 'valid_app'
  local appfilepath=../lib/sdd/apps/user/really_valid_app
  echo 'sdd_install() { local app=$SDD_INSTALL_PREFIX/bin/really_valid_app; echo '\\#!/usr/bin/env bash' > $app; chmod +x $app; }' > $appfilepath

  run sdd install really_valid_app
  [ "$status" -eq 0 ]
  [ "$output" = 'Installed "really_valid_app".' ]
  # Execute the app
  run really_valid_app
  [ "$status" -eq 0 ]

  rm $appfilepath
  [ ! -f $appfilepath ]
  SDD_INSTALL_PREFIX=${SDD_INSTALL_PREFIX:-$HOME/.local}
  rm $SDD_INSTALL_PREFIX/bin/really_valid_app
  [ ! -f $SDD_INSTALL_PREFIX/bin/really_valid_app ]
}

@test "invoking remove command without argument fails" {
  run sdd remove
  [ "$status" -eq 1 ]
  [ "$output" = 'Specify at least one app to remove.' ]
}

@test "invoking remove command with invalid app fails" {
  run sdd remove invalid_app
  [ "$status" -eq 2 ]
  [ "$output" = 'App "invalid_app" could not be found.' ]
}

@test "invoking remove command with valid app but without sdd_remove present fails" {
  local appfilepath=../lib/sdd/apps/user/valid_app
  touch $appfilepath

  run sdd remove valid_app
  [ "$status" -eq 4 ]
  [[ "$output" = 'Error removing "valid_app": '* ]]
  [[ "$output" = *'sdd_remove: command not found' ]]

  rm $appfilepath
  [ ! -f $appfilepath ]
}

@test "invoking remove command with valid app succeeds" {
  # Assume that 'valid_app' was installed properly
  SDD_INSTALL_PREFIX=${SDD_INSTALL_PREFIX:-$HOME/.local}
  mkdir -p "$SDD_INSTALL_PREFIX"/bin
  apppath="$SDD_INSTALL_PREFIX"/bin/valid_app
  echo '#!/usr/bin/env bash' > "$apppath"
  chmod +x "$apppath"

  run valid_app
  [ "$status" -eq 0 ]

  # Create app management file for 'valid_app' containing an sdd_remove
  # function that removes the executable 'valid_app'
  local appfilepath=../lib/sdd/apps/user/valid_app
  echo "sdd_remove() { rm $apppath; }" > $appfilepath

  run sdd remove valid_app
  [ "$status" -eq 0 ]
  [ "$output" = 'Removed "valid_app".' ]
  [ ! -f "$apppath" ]

  rm $appfilepath
}
