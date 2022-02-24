@test "docker-compose of recent version can be installed and uninstalled" {
  run sdd install docker-compose
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "docker-compose".' ]

  run docker-compose --version
  [ $status -eq 0 ]

  run sdd uninstall docker-compose
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "docker-compose".' ]

  run which docker-compose
  [ $status -eq 1 ]
}
