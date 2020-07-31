@test "gh of recent version can be installed and uninstalled" {
  run sdd install gh
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "gh".' ]

  run gh --version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash-completion/completions/gh ]
  [ -f ~/.local/share/zsh/site-functions/_gh ]
  [ -f ~/.local/share/man/man1/gh.1 ]

  run sdd uninstall gh
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "gh".' ]

  run which gh
  [ $status -eq 1 ]
}
