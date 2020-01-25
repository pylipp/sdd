zsh_mock=~/.local/bin/zsh

setup() {
  mkdir -p $(dirname $zsh_mock)
  touch $zsh_mock
  chmod +x $zsh_mock
}

teardown() {
  rm -f $zsh_mock
}

@test "oh-my-zsh of recent version can be installed and uninstalled" {
  run sdd install oh-my-zsh
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "oh-my-zsh".' ]

  [ -d ~/.oh-my-zsh ]

  run sdd uninstall oh-my-zsh
  [ $status -eq 0 ]
  [ "$output" = 'Succeeded to uninstall "oh-my-zsh".' ]
}
