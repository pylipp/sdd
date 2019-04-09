@test "jq of recent version can be installed and uninstalled" {
  run sdd install jq
  [ $status -eq 0 ]
  [ "$output" = 'Installed "jq".' ]

  run jq --version
  [ $status -eq 0 ]
  [ $output = "jq-1.6" ]

  run sdd uninstall jq
  [ $status -eq 0 ]
  [ "$output" = 'Uninstalled "jq".' ]

  run which jq
  [ $status -eq 1 ]
}
