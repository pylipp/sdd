@test "auth0 of recent version can be installed and uninstalled" {
  run sdd install auth0
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "auth0".' ]

  run auth0 --version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash-completion/completions/auth0 ]

  run sdd uninstall auth0
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "auth0".' ]

  run which auth0
  [ $status -eq 1 ]
}