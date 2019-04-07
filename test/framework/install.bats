teardown() {
  rm -rf $HOME/.local/bin/sdd $HOME/.local/lib/sdd
  rm -rf /usr/bin/sdd /usr/lib/sdd
}

@test "Default sdd installation succeeds" {
  run ../install.sh
  [ $status -eq 0 ]

  [ -e "$HOME/.local/bin/sdd" ]
  
  run "$HOME/.local/bin/sdd"
  [ "$status" -eq 0 ]
}

@test "Custom sdd installation succeeds" {
  export PREFIX=/usr
  run ../install.sh
  [ $status -eq 0 ]

  [ -e /usr/bin/sdd ]
  
  run /usr/bin/sdd
  [ "$status" -eq 0 ]
}
