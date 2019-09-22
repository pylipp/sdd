load '/usr/local/libexec/bats-support/load.bash'
load '/usr/local/libexec/bats-assert/load.bash'

@test "diff-so-fancy of recent version can be installed and uninstalled" {
  run sdd install diff-so-fancy
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[1]}" = 'Installed "diff-so-fancy".' ]

  run diff-so-fancy --colors
  assert_success

  run sdd uninstall diff-so-fancy
  [ $status -eq 0 ]
  [ "$output" = 'Uninstalled "diff-so-fancy".' ]

  run which diff-so-fancy
  [ $status -eq 1 ]
}
