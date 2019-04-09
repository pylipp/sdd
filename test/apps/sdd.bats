@test "sdd of recent version is present in PATH" {
  run sdd install sdd
  [ $status -eq 0 ]
  [ "$output" = 'Installed "sdd".' ]

  # Installed sdd should be first in PATH
  run which sdd
  [ $status -eq 0 ]
  [ $output = "$HOME/.local/bin/sdd" ]

  # Delete binary such that it does not interfere with the tested binary in /opt/sdd
  rm "$HOME/.local/bin/sdd"
}
