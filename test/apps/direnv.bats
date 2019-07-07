@test "direnv of recent version can be installed and uninstalled" {
  run sdd install direnv
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[1]}" = 'Installed "direnv".' ]

  run direnv version
  [ $status -eq 0 ]

  run sdd uninstall direnv
  [ $status -eq 0 ]
  [ "$output" = 'Uninstalled "direnv".' ]

  run which direnv
  [ $status -eq 1 ]
}
