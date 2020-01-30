@test "sdd of recent version can be installed and uninstalled" {
  run sdd install sdd
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "sdd".' ]

  # Installed sdd should be first in PATH
  run which sdd
  [ $status -eq 0 ]
  [ $output = "$HOME/.local/bin/sdd" ]

  # hen-egg issue... at the time of writing the test, the sdd_upgrade or the
  # sdd_uninstall command is not yet present in the repo which is cloned for
  # installation. Hence explicitely use the 'test' binary
  run /opt/sdd/bin/sdd upgrade sdd
  [ $status -eq 0 ]

  run /opt/sdd/bin/sdd uninstall sdd
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "sdd".' ]

  # The binary under test is still in the path
  run which sdd
  [ $status -eq 0 ]
  [ $output = /opt/sdd/bin/sdd ]

  [ ! -e "$HOME/.local/lib/sdd" ]
}
