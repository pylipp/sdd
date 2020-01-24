@test "diff-so-fancy of recent version can be installed and uninstalled" {
  run sdd install diff-so-fancy
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Installed "diff-so-fancy".' ]

  run diff-so-fancy --colors
  [ $status -eq 0 ]

  run sdd uninstall diff-so-fancy
  [ $status -eq 0 ]
  [ "$output" = 'Uninstalled "diff-so-fancy".' ]

  run which diff-so-fancy
  [ $status -eq 1 ]
}
