# Utility functions for sdd framework

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

utils_install() {
    # Install one or more apps
    if [ $# -eq 0 ]; then
        printf 'Specify at least one app to install.' >&2
        return 1
    fi

    # Iterate over arguments
    local appfilepath
    for app in "$@"; do
        appfilepath="$SCRIPTDIR/../apps/user/$app"

        # Check whether filepath exists
        if [ ! -f "$appfilepath" ]; then
            printf 'App "%s" could not be found.' "$app" >&2
            return 2
        else
            # Source app management file and execute installation function if found
            source "$appfilepath"
            sdd_install 2>/dev/null || { printf 'No sdd_install function for "%s" provided' "$app" >&2; return 4; }
        fi
    done

    return 0
}
