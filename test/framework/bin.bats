@test "invoking main executable" {
  run sdd
  [ "$status" -eq 0 ]
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
  [ "$output" = 'No sdd_install function for "valid_app" provided' ]

  rm $appfilepath
  [ ! -f $appfilepath ]
}

@test "invoking install command with valid app succeeds" {
  # Create app management file for 'valid_app' containing an sdd_install
  # function that creates an executable 'valid_app'
  local appfilepath=../lib/sdd/apps/user/valid_app
  echo 'sdd_install() { local app=$SDD_INSTALL_PREFIX/bin/valid_app; echo '\\#!/usr/bin/env bash' > $app; chmod +x $app; }' > $appfilepath

  run sdd install valid_app
  [ "$status" -eq 0 ]
  [ "$output" = 'Installed "valid_app".' ]
  # Execute the app
  run valid_app
  [ "$status" -eq 0 ]

  rm $appfilepath
  [ ! -f $appfilepath ]
  rm $SDD_INSTALL_PREFIX/bin/valid_app
  [ ! -f $SDD_INSTALL_PREFIX/bin/valid_app ]
}
