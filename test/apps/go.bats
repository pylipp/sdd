@test "go of recent version can be installed and uninstalled" {
  run sdd install go
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "go".' ]

  run ~/.local/go/bin/go version
  [ $status -eq 0 ]

  run sdd uninstall go
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "go".' ]

  run which go
  [ $status -eq 1 ]
}
