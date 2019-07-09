setup() {
    SDD_INSTALL_PREFIX=${SDD_INSTALL_PREFIX:-$HOME/.local}
    export SDD_INSTALL_PREFIX
    mkdir -p "$SDD_INSTALL_PREFIX"/bin
}

teardown() {
  rm -rf ~/.virtualenvs

  rm -rf "$SDD_INSTALL_PREFIX"/bin
  unset SDD_INSTALL_PREFIX
}

@test "installation of python app is enabled" {
  source ../lib/sdd/framework/python.bash

  run sdd_pyinstall pip
  [ "$status" -eq 0 ]

  run pip --version
  [ "$status" -eq 0 ]

  run which pip
  [ "$output" = "$SDD_INSTALL_PREFIX/bin/pip" ]
  [ "$status" -eq 0 ]

  unset -f sdd_pyinstall
}

@test "invoking pyinstall command with valid app succeeds" {
  run sdd pyinstall pip
  [ $status -eq 0 ]
  [ "${lines[-1]}" = 'Installed "pip".' ]

  run pip --version
  [ $status -eq 0 ]
}
