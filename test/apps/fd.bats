load '/usr/local/libexec/bats-support/load.bash'
load '/usr/local/libexec/bats-assert/load.bash'

@test "fd of recent version can be installed and uninstalled" {
  run sdd install fd
  assert_success
  assert_line -n 0 -p 'Latest version available: '
  assert_output -p 'Installed "fd".'

  run fd --version
  [ $status -eq 0 ]

  run sdd uninstall fd
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Uninstalled "fd".' ]

  run which fd
  [ $status -eq 1 ]
}
