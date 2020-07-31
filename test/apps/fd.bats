@test "fd of recent version can be installed and uninstalled" {
  run sdd install fd
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "fd".' ]

  run fd --version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash-completion/completions/fd ]
  [ -f ~/.local/share/zsh/site-functions/_fd ]

  run sdd uninstall fd
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "fd".' ]

  run which fd
  [ $status -eq 1 ]
}
