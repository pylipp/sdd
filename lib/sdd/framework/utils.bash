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

Commands:
    install
    uninstall
    list

General options:
    --help      Display help message

Options for list command:
    --installed List installed apps

END_OF_HELP_TEXT
}

utils_install() {
    # Install one or more apps
    if [ $# -eq 0 ]; then
        printf 'Specify at least one app to install.\n' >&2
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
            # Source app management file and execute installation function if found
            source "$appfilepath"

            local version=$(sdd_fetch_latest_version 2>/dev/null)
            if [ ! -z $version ]; then
                printf 'Latest version available: %s\n' $version
            fi

            local stderrlog=/tmp/sdd-install-$app.stderr
            sdd_install $version 2>$stderrlog

            if [ $? -eq 0 ]; then
                printf 'Installed "%s".\n' "$app"

                if [ ! -z $version ]; then
                    # Record installed app and version
                    echo $app=$version >> "$SDD_DATA_DIR"/apps/installed
                fi
            else
                printf 'Error installing "%s": %s\n' "$app" "$(<$stderrlog)" >&2
                return 4
            fi
        fi
    done

    return 0
}

utils_uninstall() {
    # Uninstall one or more apps
    if [ $# -eq 0 ]; then
        printf 'Specify at least one app to uninstall.\n' >&2
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
            source "$appfilepath"

            local stderrlog=/tmp/sdd-uninstall-$app.stderr
            sdd_uninstall 2>$stderrlog

            if [ $? -eq 0 ]; then
                printf 'Uninstalled "%s".\n' "$app"
            else
                printf 'Error uninstalling "%s": %s\n' "$app" "$(<$stderrlog)" >&2
                return 4
            fi
        fi
    done
}

utils_list() {
    local option=$1

    if [ "$option" = "--installed" ]; then
        # List app names only; versions can be queried separately
        cut -d"=" -f1 "$SDD_DATA_DIR"/apps/installed | sort | uniq
    else
        printf 'Unknown option "%s".\n' "$option" >&2
        return 1
    fi
}
