load '/usr/local/libexec/bats-support/load.bash'
load '/usr/local/libexec/bats-assert/load.bash'

validappfilepath=../lib/sdd/apps/user/valid_app
superappfilepath=../lib/sdd/apps/user/super_app
validcustomappfilepath=$HOME/.config/sdd/apps/valid_app
invalidappfilepath=../lib/sdd/apps/user/invalid_app
appsrecordfilepath=$HOME/.local/share/sdd/apps/installed

setup() {
  mkdir -p $(dirname $validcustomappfilepath)
}

teardown() {
  rm -f "$validappfilepath"
  rm -f "$superappfilepath"
  rm -f "$invalidappfilepath"
  rm -f ${SDD_INSTALL_PREFIX:-$HOME/.local}/bin/valid_app
  rm -f "$appsrecordfilepath"
  rm -rf $HOME/.config/sdd
}

@test "invoking main executable prints usage" {
  run sdd
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Usage: sdd [OPTIONS] COMMAND [APP [APP...]]" ]
}

@test "invoking unknown command fails" {
  run sdd unknown-command
  [ "$status" -eq 127 ]
  [ "$output" = 'Unknown command "unknown-command"' ]
}

@test "invoking help option prints usage" {
  run sdd --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Usage: sdd [OPTIONS] COMMAND [APP [APP...]]" ]
}

@test "invoking install command without argument fails" {
  run sdd install
  [ "$status" -eq 1 ]
  [ "$output" = 'Specify at least one app to install.' ]
}

@test "invoking install command with non-existing app fails" {
  run sdd install non_existing_app
  [ "$status" -eq 2 ]
  [ "$output" = 'App "non_existing_app" could not be found.' ]
}

@test "invoking install command with existing app but without sdd_install present fails" {
  touch $invalidappfilepath

  run sdd install invalid_app
  assert_failure 4
  assert_line -n 0 'Failed to install "invalid_app". See /tmp/sdd-install-invalid_app.stderr.'
}

@test "invoking install command with valid app succeeds" {
  # Create app management file for 'valid_app' containing an sdd_install
  # function that creates an executable 'valid_app'
  cp framework/fixtures/valid_app $validappfilepath

  run sdd install valid_app
  [ "$status" -eq 0 ]
  assert_line -n 0 'Latest version available: 1.0'
  assert_line -n 1 'Succeeded to install "valid_app".'
  assert_equal ${#lines[@]} 2

  # Execute the app
  run valid_app
  [ "$status" -eq 0 ]

  # The installed app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.0" ]
}

@test "invoking install command with valid custom app succeeds" {
  # Create app management file for 'valid_app' containing an sdd_install
  # function that creates an executable 'valid_app'
  cp framework/fixtures/valid_app $validcustomappfilepath

  run sdd install valid_app
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 'Custom install function for "valid_app" found.' ]
  [ "${lines[1]}" = 'Latest version available: 1.0' ]
  [ "${lines[2]}" = 'Succeeded to install "valid_app".' ]
  assert_equal ${#lines[@]} 3

  # Execute the app
  run valid_app
  [ "$status" -eq 0 ]

  # The installed app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.0" ]
}

@test "invoking install command with valid customized app succeeds" {
  # Custom app management file specifies newer version
  cp framework/fixtures/valid_app $validcustomappfilepath
  sed -i 's/1.0/1.1/' $validcustomappfilepath
  cp framework/fixtures/valid_app $validappfilepath

  run sdd install valid_app
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 'Custom install function for "valid_app" found.' ]
  [ "${lines[1]}" = 'Latest version available: 1.1' ]
  [ "${lines[2]}" = 'Succeeded to install "valid_app".' ]
  assert_equal ${#lines[@]} 3

  # Execute the app
  run valid_app
  [ "$status" -eq 0 ]

  # The installed app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.1" ]
}

@test "invoking install command with valid customized app without sdd_fetch_latest_version succeeds" {
  echo "sdd_install() { return 0; }" > $validcustomappfilepath
  cp framework/fixtures/valid_app $validappfilepath

  run sdd install valid_app
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 'Custom install function for "valid_app" found.' ]
  [ "${lines[1]}" = 'Latest version available: 1.0' ]
  [ "${lines[2]}" = 'Succeeded to install "valid_app".' ]
  assert_equal ${#lines[@]} 3

  # Execute the app
  run valid_app
  [ "$status" -eq 0 ]

  # The installed app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.0" ]
}

@test "invoking install command with valid and non-existing app installs only valid one" {
  cp framework/fixtures/valid_app $validappfilepath

  run sdd install valid_app non_existing_app
  assert_failure 2
  [ "${lines[0]}" = 'App "non_existing_app" could not be found.' ]
  # Two more lines about installing valid_app
  assert_equal ${#lines[@]} 3

  run valid_app
  [ "$status" -eq 0 ]

  run which invalid_app
  [ "$status" -eq 1 ]
}

@test "invoking install command with valid and invalid app installs only valid one" {
  cp framework/fixtures/valid_app $validappfilepath
  touch $invalidappfilepath

  run sdd install valid_app invalid_app
  assert_failure 4
  assert_line -n 0 'Latest version available: 1.0'
  assert_line -n 1 'Succeeded to install "valid_app".'
  assert_line -n 2 'Failed to install "invalid_app". See /tmp/sdd-install-invalid_app.stderr.'
  assert_equal ${#lines[@]} 3

  run valid_app
  [ "$status" -eq 0 ]

  run which invalid_app
  [ "$status" -eq 1 ]
}

@test "invoking install command with valid custom and non-existing app installs only custom one" {
  cp framework/fixtures/valid_app $validcustomappfilepath

  run sdd install valid_app non_existing_app
  assert_failure 2
  [ "${lines[0]}" = 'App "non_existing_app" could not be found.' ]
  [ "${lines[1]}" = 'Custom install function for "valid_app" found.' ]
  [ "${lines[2]}" = 'Latest version available: 1.0' ]
  [ "${lines[3]}" = 'Succeeded to install "valid_app".' ]
  assert_equal ${#lines[@]} 4

  run valid_app
  [ "$status" -eq 0 ]

  run which non_existing_app
  [ "$status" -eq 1 ]
}

@test "invoking install command with valid app and version succeeds" {
  cp framework/fixtures/valid_app $validappfilepath

  run sdd install valid_app=1.1
  [ "$status" -eq 0 ]
  assert_line -n 0 'Specified version: 1.1'
  assert_line -n 1 'Succeeded to install "valid_app".'
  assert_equal ${#lines[@]} 2

  # The installed app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.1" ]
}

@test "invoking uninstall command without argument fails" {
  run sdd uninstall
  [ "$status" -eq 1 ]
  [ "$output" = 'Specify at least one app to uninstall.' ]
}

@test "invoking uninstall command with non-existing app fails" {
  run sdd uninstall non_existing_app
  [ "$status" -eq 2 ]
  [ "$output" = 'App "non_existing_app" could not be found.' ]
}

@test "invoking uninstall command with existing app but without sdd_uninstall present fails" {
  touch $invalidappfilepath

  run sdd uninstall invalid_app
  assert_failure 8
  assert_line -n 0 'Failed to uninstall "invalid_app". See /tmp/sdd-uninstall-invalid_app.stderr.'
}

@test "invoking uninstall command with valid app succeeds" {
  # Create app management file for 'valid_app' containing an sdd_uninstall
  # function that uninstalls the executable 'valid_app'
  cp framework/fixtures/valid_app $validappfilepath

  # Install 'valid_app'
  sdd install valid_app
  run valid_app
  [ "$status" -eq 0 ]

  run sdd uninstall valid_app
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 'Succeeded to uninstall "valid_app".' ]
  assert_equal ${#lines[@]} 1

  # Check log file content
  run cat /tmp/sdd-uninstall-valid_app.stderr
  assert_output 'Succeeded to uninstall "valid_app".'

  run which valid_app
  [ "$status" -eq 1 ]
}

@test "invoking uninstall command with valid customized app succeeds" {
  echo "sdd_uninstall() { touch /tmp/uninstalled; }" > $validcustomappfilepath
  cp framework/fixtures/valid_app $validappfilepath

  run sdd install valid_app
  [ "$status" -eq 0 ]

  run sdd uninstall valid_app
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = 'Custom uninstall function for "valid_app" found.' ]
  [ "${lines[1]}" = 'Succeeded to uninstall "valid_app".' ]
  assert_equal ${#lines[@]} 2

  # This file is expected to have been created by the custom sdd_uninstall
  [ -f /tmp/uninstalled ]

  run which valid_app
  [ "$status" -eq 1 ]
}

@test "invoking upgrade command without argument fails" {
  run sdd upgrade
  assert_failure 1
  assert_output 'Specify at least one app to upgrade.'
  assert_equal ${#lines[@]} 1
}

@test "invoking upgrade command with non-existing app fails" {
  run sdd upgrade non_existing_app
  assert_failure 2
  assert_line -n 0 'App "non_existing_app" could not be found.'
  assert_equal ${#lines[@]} 1
}

@test "invoking upgrade command with existing app succeeds" {
  # Assume app is already installed
  cp framework/fixtures/valid_app $validappfilepath
  sdd install valid_app

  # Bump version number
  sed -i 's/1.0/1.1/' $validappfilepath

  run sdd upgrade valid_app
  assert_success
  assert_line -n 0 'Latest version available: 1.1'
  assert_line -n 1 'Succeeded to upgrade "valid_app".'
  assert_equal ${#lines[@]} 2

  # Execute the app
  run valid_app
  assert_success

  # The installed app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.1" ]
}

@test "invoking upgrade command with valid app and version succeeds" {
  cp framework/fixtures/valid_app $validappfilepath
  sdd install valid_app

  # Bump version number
  sed -i 's/1.0/1.1/' $validappfilepath

  run sdd upgrade valid_app=1.1
  assert_success
  assert_line -n 0 'Specified version: 1.1'
  assert_line -n 1 'Succeeded to upgrade "valid_app".'
  assert_equal ${#lines[@]} 2

  # The upgraded app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.1" ]
}

@test "invoking upgrade command with existing app but without sdd_uninstall present fails" {
  touch $invalidappfilepath

  run sdd upgrade invalid_app
  assert_failure 8
  assert_line -n 0 'Failed to upgrade "invalid_app". See /tmp/sdd-upgrade-invalid_app.stderr.'
  assert_equal ${#lines[@]} 1
}

@test "invoking upgrade command with existing app but without sdd_install present fails" {
  cat > $invalidappfilepath <<FILE
  #!/usr/bin/env bash
  sdd_uninstall() { return; }
FILE

  run sdd upgrade invalid_app
  assert_failure 4
  assert_line -n 0 'Failed to upgrade "invalid_app". See /tmp/sdd-upgrade-invalid_app.stderr.'
  assert_equal ${#lines[@]} 1
}

@test "invoking upgrade command with valid and non-existing app upgrades only valid one" {
  cp framework/fixtures/valid_app $validappfilepath

  run sdd upgrade valid_app non_existing_app
  assert_failure 2
  [ "${lines[0]}" = 'App "non_existing_app" could not be found.' ]
  # Two more lines about upgrading valid_app
  assert_equal ${#lines[@]} 3

  run valid_app
  [ "$status" -eq 0 ]

  run which invalid_app
  [ "$status" -eq 1 ]
}

@test "invoking upgrade command with existing app and sdd_upgrade succeeds" {
  cp framework/fixtures/valid_app $validappfilepath
  echo 'sdd_upgrade() { sdd_install >/dev/null; echo Upgrading to $1...; }' >> $validappfilepath

  run sdd upgrade valid_app
  assert_success
  assert_line -n 0 'Latest version available: 1.0'
  assert_line -n 1 'Succeeded to upgrade "valid_app".'
  assert_equal ${#lines[@]} 2

  run valid_app
  assert_success

  run cat /tmp/sdd-upgrade-valid_app.stderr
  assert_line -n 0 'Upgrading to 1.0...'
  assert_line -n 1 'Succeeded to upgrade "valid_app".'

  # The upgraded app version is recorded
  [ "$(tail -n1 $appsrecordfilepath)" = "valid_app=1.0" ]
}

@test "invoking upgrade command with existing app and invalid sdd_upgrade fails" {
  echo 'sdd_upgrade() { return 1; }' > $invalidappfilepath

  run sdd upgrade invalid_app
  assert_failure 16
  assert_line -n 0 'Failed to upgrade "invalid_app". See /tmp/sdd-upgrade-invalid_app.stderr.'
  assert_equal ${#lines[@]} 1
}

@test "invoking upgrade command with valid custom app succeeds" {
  echo 'sdd_upgrade() { echo Upgrading...; }' > $validcustomappfilepath

  run sdd upgrade valid_app
  assert_success
  assert_line -n 0 'Custom upgrade function for "valid_app" found.'
  assert_line -n 1 'Succeeded to upgrade "valid_app".'
  assert_equal ${#lines[@]} 2

  run cat /tmp/sdd-upgrade-valid_app.stderr
  assert_line -n 0 'Upgrading...'
}

@test "invoking list with --installed option displays installed apps including versions" {
  cp framework/fixtures/valid_app $validappfilepath
  sdd install valid_app

  run sdd list --installed
  [ $status -eq 0 ]
  [ "${lines[0]}" = "valid_app=1.0" ]
  assert_equal ${#lines[@]} 1

  # Bump version number
  sed -i 's/1.0/1.1/' $validappfilepath
  sdd install valid_app

  run sdd list --installed
  [ $status -eq 0 ]
  [ "${lines[0]}" = "valid_app=1.1" ]
  assert_equal ${#lines[@]} 1

  sdd uninstall valid_app
  run sdd list --installed
  [ $status -eq 0 ]
  [ "$output" = "" ]
}

@test "invoking list with --available option displays available apps" {
  cp framework/fixtures/valid_app $validappfilepath
  touch $(dirname $validcustomappfilepath)/custom_app

  run sdd list --available
  assert_success
  assert_line -n 0 "Built-in:"
  assert_output -p "- valid_app"
  [ "${lines[-2]}" = "Custom:" ]
  [ "${lines[-1]}" = "- custom_app" ]

  # Two lines for categories, one for 'custom_app'. Empty line not counted by bats
  expected_nr_lines=3
  ((expected_nr_lines+=$(find ../lib/sdd/apps/user -type f | wc -l)))
  assert_equal ${#lines[@]} $expected_nr_lines
}

@test "invoking list with --upgradable option displays upgradable apps" {
  # Install two apps
  cp framework/fixtures/valid_app $validappfilepath
  cp framework/fixtures/valid_app $superappfilepath
  sed 's/valid/super/g' $superappfilepath

  sdd install valid_app super_app

  # Bump version numbers
  sed -i 's/1.0/2.0/' $validappfilepath
  sed -i 's/1.0/1.5/' $superappfilepath

  run sdd list --upgradable
  assert_success
  assert_line -n 0 'super_app (1.0 -> 1.5)'
  assert_line -n 1 'valid_app (1.0 -> 2.0)'
  assert_equal ${#lines[@]} 2
}
