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

_validate_apps() {
    local return_code=0
    local manage=$1
    shift
    local appfilepath
    local apps=()
    for app in "$@"; do
        appfilepath="$SCRIPTDIR/../apps/user/$app"

        # Check whether filepath exists
        if [ ! -f "$appfilepath" ]; then
            printf 'App "%s" could not be found.\n' "$app" >&2
            return_code=2
        elif ! grep -q sdd_$manage "$appfilepath"; then
            printf "No $manage function present for \"%s\".\n" "$app" >&2
            return_code=3
        else
            apps+=($app)
        fi
    done

    echo ${apps[@]}
    return $return_code
}

utils_install() {
    local return_code=0

    # Install one or more apps
    if [ $# -eq 0 ]; then
        printf 'Specify at least one app to install.\n' >&2
        return 1
    fi

    # Separate definition and command substitution because 'local' itself is a
    # command, hence 'local apps=($(command))' would always have exit code 0
    local apps=()
    apps=($(_validate_apps install "$@"))
    return_code=$?

    local appfilepath
    for app in "${apps[@]}"; do
        appfilepath="$SCRIPTDIR/../apps/user/$app"

        # Source app management file and execute installation function if found
        source "$appfilepath"

        local version
        version=$(sdd_fetch_latest_version 2>/dev/null)
        if [ $? -eq 0 ]; then
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
            return_code=4
        fi
    done

    return $return_code
}

utils_uninstall() {
    local return_code=0

    # Uninstall one or more apps
    if [ $# -eq 0 ]; then
        printf 'Specify at least one app to uninstall.\n' >&2
        return 1
    fi

    local apps=()
    apps=($(_validate_apps uninstall "$@"))
    return_code=$?

    local appfilepath
    for app in "${apps[@]}"; do
        appfilepath="$SCRIPTDIR/../apps/user/$app"

        source "$appfilepath"

        local stderrlog=/tmp/sdd-uninstall-$app.stderr
        sdd_uninstall 2>$stderrlog

        if [ $? -eq 0 ]; then
            printf 'Uninstalled "%s".\n' "$app"
            # Remove app install records
            sed -i "/^$app/d" "$SDD_DATA_DIR"/apps/installed
        else
            printf 'Error uninstalling "%s": %s\n' "$app" "$(<$stderrlog)" >&2
            return_code=4
        fi
    done

    return $return_code
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
