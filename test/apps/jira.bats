@test "jira of recent version can be installed and uninstalled" {
  run sdd install jira
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "jira".' ]

  run jira version
  [ $status -eq 0 ]

  [ -f ~/.local/share/bash_completion/jira ]
  [ -f ~/.local/share/zsh/site-functions/_jira ]

  run sdd uninstall jira
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "jira".' ]

  run which jira
  [ $status -eq 1 ]
}
