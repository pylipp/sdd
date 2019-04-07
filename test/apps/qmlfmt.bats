@test "qmlfmt of recent version is present in PATH" {
  skip
  run sdd install qmlfmt
  echo $output
  [ $status -eq 0 ]
  [ "$output" = 'Installed "qmlfmt".' ]

  run qmlfmt --version
  [ $status -eq 0 ]
  echo $output
  [ $output = "jq-1.6" ]
}
