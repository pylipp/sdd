@test "fd of recent version can be installed and uninstalled" {
  run sdd install fd
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "fd".' ]

  run fd --version
  [ $status -eq 0 ]

  run sdd uninstall fd
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "fd".' ]

  run which fd
  [ $status -eq 1 ]
}
