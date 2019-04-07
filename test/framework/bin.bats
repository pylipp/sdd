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
