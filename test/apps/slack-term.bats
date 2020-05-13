@test "slack-term of recent version can be installed and uninstalled" {
  run sdd install slack-term
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "slack-term".' ]

  run slack-term -help
  [ $status -eq 2 ]

  run sdd uninstall slack-term
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "slack-term".' ]

  run which slack-term
  [ $status -eq 1 ]
}
