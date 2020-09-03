@test "wuzz of recent version can be installed and uninstalled" {
  run sdd install wuzz
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "wuzz".' ]

  run wuzz --version
  [ $status -eq 0 ]

  run sdd uninstall wuzz
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "wuzz".' ]

  run which wuzz
  [ $status -eq 1 ]
}
