# Utility functions for sdd framework

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

utils_usage() {
    while IFS= read -r line; do
        printf '%s\n' "$line"
    done <<END_OF_HELP_TEXT
Usage: sdd [OPTIONS] COMMAND [APP [APP...]]

A framework to manage installation of apps from web sources for non-root users
on Linux systems. For more info visit https://github.com/pylipp/sdd

APP is the name of the application to manage.

Supported commands:
    install
    uninstall

Options:
    --help      Display help message

END_OF_HELP_TEXT
}

utils_install() {
    _utils_manage install "$@"
    return $?
}

utils_uninstall() {
    _utils_manage uninstall "$@"
    return $?
}

_utils_manage() {
    local manage=$1
    shift

    # Manage one or more apps
    if [ $# -eq 0 ]; then
        printf "Specify at least one app to $manage.\n" >&2
        return 1
    fi

    # Iterate over arguments
    local appfilepath
    for app in "$@"; do
        appfilepath="$SCRIPTDIR/../apps/user/$app"

        # Check whether filepath exists
        if [ ! -f "$appfilepath" ]; then
            printf 'App "%s" could not be found.\n' "$app" >&2
            return 2
        else
            # Source app management file and execute managing function if found
            source "$appfilepath"

            local version
            if [ $manage = "install" ]; then
                version=$(sdd_fetch_latest_version 2>/dev/null)

                if [ $? -eq 0 ]; then
                    printf 'Latest version available: %s\n' $version
                fi
            fi

            local stderrlog=/tmp/sdd-$manage-$app.stderr
            sdd_$manage $version 2>$stderrlog

            if [ $? -eq 0 ]; then
                printf "${manage^}ed \"%s\".\n" "$app"
            else
                printf "Error ${manage}ing \"%s\": %s\n" "$app" "$(<$stderrlog)"  >&2
                return 4
            fi
        fi
    done

    return 0
}
