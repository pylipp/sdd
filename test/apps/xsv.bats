@test "xsv of recent version can be installed and uninstalled" {
  run sdd install xsv
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "xsv".' ]

  run xsv --version
  [ $status -eq 0 ]

  run sdd uninstall xsv
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "xsv".' ]

  run which xsv
  [ $status -eq 1 ]
}
