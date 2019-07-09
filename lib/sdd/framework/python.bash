# Python-development specific utility functions for sdd framework

VENV_DIR=${WORKON_HOME:-$HOME/.virtualenvs}

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
