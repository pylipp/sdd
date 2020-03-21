@test "hub of recent version can be installed and uninstalled" {
  run sdd install hub
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "hub".' ]

  run hub --version
  [ $status -eq 0 ]

  run sdd uninstall hub
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "hub".' ]

  run which hub
  [ $status -eq 1 ]
}
