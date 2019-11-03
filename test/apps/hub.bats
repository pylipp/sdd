@test "hub of recent version can be installed and uninstalled" {
  run sdd install hub
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Installed "hub".' ]

  run hub --version
  [ $status -eq 0 ]

  run sdd uninstall hub
  [ $status -eq 0 ]
  [ "$output" = 'Uninstalled "hub".' ]

  run which rg
  [ $status -eq 1 ]
}
