@test "qrcp of recent version can be installed and uninstalled" {
  run sdd install qrcp
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "qrcp".' ]

  run qrcp version
  [ $status -eq 0 ]

  run sdd uninstall qrcp
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "qrcp".' ]

  run which qrcp
  [ $status -eq 1 ]
}
