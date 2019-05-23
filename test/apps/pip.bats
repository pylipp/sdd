@test "pip of recent version can be installed and uninstalled" {
  run sdd install pip
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Installed "pip".' ]

  run pip --version
  [ $status -eq 0 ]

  run sdd uninstall pip
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Uninstalled "pip".' ]

  run which pip
  [ $status -eq 1 ]
}
