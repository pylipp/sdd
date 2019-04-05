# Utility functions for sdd framework

utils_install() {
    # Install one or more apps
    if [ $# -eq 0 ]; then
        printf 'Specify at least one app to install.' >&2
        return 1
    fi

    return 0
}
