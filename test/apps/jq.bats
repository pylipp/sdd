@test "jq of recent version can be installed and uninstalled" {
  run sdd install jq
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Installed "jq".' ]

  run jq --version
  [ $status -eq 0 ]

  run sdd uninstall jq
  [ $status -eq 0 ]
  [ "$output" = 'Uninstalled "jq".' ]

  run which jq
  [ $status -eq 1 ]
}
