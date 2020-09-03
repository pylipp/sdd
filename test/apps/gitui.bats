@test "gitui of recent version can be installed and uninstalled" {
  run sdd install gitui
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "gitui".' ]

  run gitui --version
  [ $status -eq 0 ]

  run sdd uninstall gitui
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "gitui".' ]

  run which gitui
  [ $status -eq 1 ]
}
