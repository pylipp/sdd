@test "invoking main executable" {
  run sdd
  [ "$status" -eq 0 ]
}

@test "invoking install command without argument fails" {
  run sdd install
  [ "$status" -eq 1 ]
  [ "$output" = 'Specify at least one app to install.' ]
}
