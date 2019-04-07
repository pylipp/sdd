@test "jq of recent version is present in PATH" {
  run sdd install jq
  echo $output
  [ $status -eq 0 ]
  [ "$output" = 'Installed "jq".' ]

  run jq --version
  [ $status -eq 0 ]
  [ $output = "jq-1.6" ]
}
