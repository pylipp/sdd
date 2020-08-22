@test "pandoc of recent version can be installed and uninstalled" {
  run sdd install pandoc
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "pandoc".' ]

  run pandoc --version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash-completion/completions/pandoc ]

  run sdd uninstall pandoc
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "pandoc".' ]

  run which pandoc
  [ $status -eq 1 ]
}
