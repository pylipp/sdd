@test "telegram of recent version can be installed and uninstalled" {
  run sdd install telegram
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "telegram".' ]

  run which telegram
  [ $status -eq 0 ]

  run sdd uninstall telegram
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "telegram".' ]

  run which telegram
  [ $status -eq 1 ]
}
