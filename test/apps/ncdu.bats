@test "ncdu of recent version can be installed and uninstalled" {
  run sdd install ncdu
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "ncdu".' ]

  run ncdu -v
  [ $status -eq 0 ]

  run sdd uninstall ncdu
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "ncdu".' ]

  run which ncdu
  [ $status -eq 1 ]
}
