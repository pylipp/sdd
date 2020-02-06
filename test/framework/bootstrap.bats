teardown() {
  rm -rf $HOME/.local/bin/sdd $HOME/.local/lib/sdd
  rm -rf /usr/bin/sdd /usr/lib/sdd
}

@test "Default sdd installation succeeds" {
  [ ! -e "$HOME/.local/share/sdd/apps/installed" ]

  run ../bootstrap.sh
  [ $status -eq 0 ]

  [ -e "$HOME/.local/bin/sdd" ]

  run grep '^sdd=' "$HOME/.local/share/sdd/apps/installed"
  [ $status -eq 0 ]
  
  run "$HOME/.local/bin/sdd"
  [ "$status" -eq 0 ]

  run grep '^v' <("$HOME/.local/bin/sdd" --version)
  [ "$status" -eq 0 ]
}

@test "Custom sdd installation succeeds" {
  export PREFIX=/usr
  run ../bootstrap.sh
  [ $status -eq 0 ]

  [ -e /usr/bin/sdd ]
  
  run /usr/bin/sdd
  [ "$status" -eq 0 ]
}
