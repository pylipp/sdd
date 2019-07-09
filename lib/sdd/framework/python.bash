# Python-development specific utility functions for sdd framework

VENV_DIR=${WORKON_HOME:-$HOME/.virtualenvs}

python_install() {
    local return_code=1
    local app=$1

    local stderrlog=/tmp/sdd-pyinstall-$app.stderr

    sdd_pyinstall $app 2>>$stderrlog

    if [ $? -eq 0 ]; then
        printf 'Installed "%s".\n' "$app"
        return_code=0
    fi

    return $return_code
}

sdd_pyinstall() {
    set -e

    local app=$1

    # Create venv and activate it
    local venv="$VENV_DIR/$app"
    python3 -m venv "$venv"
    source "$venv"/bin/activate

    # Update pip
    pip install -U pip

    # Install app
    pip install "$app"

    # Set up relevant executable symlink
    ln -s "$venv/bin/$app" "$SDD_INSTALL_PREFIX/bin/$app"
}
