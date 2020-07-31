@test "pip of recent version can be installed, upgraded and uninstalled" {
  run sdd install pip=19.0
  [ $status -eq 0 ]
  [ "${lines[0]}" = 'Specified version: 19.0' ]
  [ "${lines[-1]}" = 'Succeeded to install "pip".' ]

  run pip --version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash-completion/completions/pip ]
  [ -f ~/.local/share/zsh/site-functions/_pip ]

  run sdd upgrade pip=20.0.1
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to upgrade "pip".' ]

  run sdd uninstall pip
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "pip".' ]

  run which pip
  [ $status -eq 1 ]
}
