@test "ffsend of recent version can be installed and uninstalled" {
  run sdd install ffsend
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "ffsend".' ]

  run ffsend --version
  [ $status -eq 0 ]

  run sdd uninstall ffsend
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "ffsend".' ]

  run which ffsend
  [ $status -eq 1 ]
}
