@test "qmlfmt of recent version is present in PATH" {
  skip
  run sdd install qmlfmt
  echo $output
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "qmlfmt".' ]

  run qmlfmt --version
  [ $status -eq 0 ]
}
