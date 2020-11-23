@test "git-trim of recent version can be installed and uninstalled" {
  run sdd install git-trim
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "git-trim".' ]

  run git-trim --version
  [ $status -eq 0 ]

  run sdd uninstall git-trim
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "git-trim".' ]

  run which git-trim
  [ $status -eq 1 ]
}
