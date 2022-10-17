@test "borg of recent version can be installed and uninstalled" {
  run sdd install borg
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "borg".' ]

  run borg --version
  [ $status -eq 0 ]

  run sdd uninstall borg
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "borg".' ]

  run which borg
  [ $status -eq 1 ]
}
