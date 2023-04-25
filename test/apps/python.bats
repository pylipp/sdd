@test "python of recent version can be installed and uninstalled" {
  run sdd install python
  [ $status -eq 0 ]
  [[ "${lines[0]}" = 'Latest version available: '* ]]
  [ "${lines[-1]}" = 'Succeeded to install "python".' ]

  run ~/.local/python/3.10.9+20230116/bin/python3 --version
  [ $status -eq 0 ]

  run sdd uninstall python
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Succeeded to uninstall "python".' ]
}
