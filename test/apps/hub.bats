load '/usr/local/libexec/bats-support/load.bash'
load '/usr/local/libexec/bats-assert/load.bash'

@test "hub of recent version can be installed and uninstalled" {
  run sdd install hub
  assert_success
  assert_line -n 0 -p 'Latest version available: '
  assert_output -p 'Installed "hub".'

  run hub --version
  [ $status -eq 0 ]

  run sdd uninstall hub
  [ $status -eq 0 ]
  [ "$output" = 'Uninstalled "hub".' ]

  run which rg
  [ $status -eq 1 ]
}
