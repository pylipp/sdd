@test "xh of recent version can be installed and uninstalled" {
  run sdd install xh
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "xh".' ]

  run xh --version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash-completion/completions/xh ]
  [ -f ~/.local/share/zsh/site-functions/_xh ]

  run sdd uninstall xh
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "xh".' ]

  run which xh
  [ $status -eq 1 ]
}
