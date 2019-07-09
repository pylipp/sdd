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

  run python_install pip
  [ "$status" -eq 0 ]

  run pip --version
  [ "$status" -eq 0 ]

  run which pip
  [ "$output" = "$SDD_INSTALL_PREFIX/bin/pip" ]
  [ "$status" -eq 0 ]

  unset -f python_install
}
