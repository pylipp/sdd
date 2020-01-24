@test "shellcheck of recent version can be installed and uninstalled" {
  run sdd install shellcheck
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Installed "shellcheck".' ]

  run shellcheck --version
  [ $status -eq 0 ]

  run sdd uninstall shellcheck
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Uninstalled "shellcheck".' ]

  run which shellcheck
  [ $status -eq 1 ]
}
