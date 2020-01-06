load '/usr/local/libexec/bats-support/load.bash'
load '/usr/local/libexec/bats-assert/load.bash'

@test "shellcheck of recent version can be installed and uninstalled" {
  run sdd install shellcheck
  assert_success
  assert_line -n 0 -p 'Latest version available: '
  assert_output -p 'Installed "shellcheck".'

  run shellcheck --version
  [ $status -eq 0 ]

  run sdd uninstall shellcheck
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Uninstalled "shellcheck".' ]

  run which shellcheck
  [ $status -eq 1 ]
}
