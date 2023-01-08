@test "circleci of recent version can be installed and uninstalled" {
  run sdd install circleci
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "circleci".' ]

  run circleci version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash-completion/completions/circleci ]
  [ -f ~/.local/share/zsh/site-functions/_circleci ]

  run sdd uninstall circleci
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "circleci".' ]

  run which circleci
  [ $status -eq 1 ]
}
