@test "dasel of recent version can be installed and uninstalled" {
  run sdd install dasel
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "dasel".' ]

  run dasel --version
  [ $status -eq 0 ]

  run sdd uninstall dasel
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "dasel".' ]

  run which dasel
  [ $status -eq 1 ]
}
