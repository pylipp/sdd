@test "bat of recent version can be installed and uninstalled" {
  run sdd install bat
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "bat".' ]

  run bat --version
  [ $status -eq 0 ]

  run sdd uninstall bat
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "bat".' ]

  run which bat
  [ $status -eq 1 ]
}
