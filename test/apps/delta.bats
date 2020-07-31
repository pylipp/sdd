@test "delta of recent version can be installed and uninstalled" {
  # Pin version because atm the latest version is tagged 'windows-strip-binary'
  # which is not a valid version identifier and cannot be resolved in Github URLs
  run sdd install delta=0.1.1
  [ $status -eq 0 ]
  # [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "delta".' ]

  run delta --version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash-completion/completions/delta ]

  run sdd uninstall delta
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "delta".' ]

  run which delta
  [ $status -eq 1 ]
}
