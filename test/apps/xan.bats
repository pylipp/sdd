@test "xan of recent version can be installed and uninstalled" {
  run sdd install xan
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "xan".' ]

  run xan --version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash-completion/completions/xan ]
  [ -f ~/.local/share/zsh/site-functions/_xan ]

  run sdd uninstall xan
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "xan".' ]

  run which xan
  [ $status -eq 1 ]
}
