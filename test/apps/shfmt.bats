@test "shfmt of recent version can be installed and uninstalled" {
  run sdd install shfmt
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "shfmt".' ]

  run shfmt --version
  [ $status -eq 0 ]

  run sdd uninstall shfmt
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "shfmt".' ]

  run which shfmt
  [ $status -eq 1 ]
}
