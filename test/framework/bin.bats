@test "invoking main executable" {
  run sdd
  [ "$status" -eq 0 ]
}
