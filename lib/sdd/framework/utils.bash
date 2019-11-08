# Utility functions for sdd framework

FRAMEWORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

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
    --version   Display version information

Options for list command:
    --installed List installed apps
    --available List apps available for installation

END_OF_HELP_TEXT
}

utils_version() {
    if [ ! -e "$SDD_DATA_DIR"/apps/installed ]; then
        printf 'Cannot find %s.\n' "$SDD_DATA_DIR"/apps/installed >&2
        return 1;
    fi

    tac "$SDD_DATA_DIR"/apps/installed | grep -m 1 '^sdd=' | cut -d '=' -f2
}

_validate_apps() {
    local return_code=0
    local appfilepath
    local apps=()
    for app in "$@"; do
        local nr_misses=0

        for dir in "$FRAMEWORKDIR/../apps/user" "$HOME/.config/sdd/apps"; do
            appfilepath="$dir/$app"

            # Check whether app available
            if [ ! -f "$appfilepath" ]; then
                ((nr_misses++))
            fi
        done

        if [ $nr_misses -eq 2 ]; then
            printf 'App "%s" could not be found.\n' "$app" >&2
            return_code=2
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

    # Extract only app names from arguments for validation
    local all_apps=()
    for arg in "$@"; do
        all_apps+=($(echo $arg | cut -d"=" -f1))
    done

    local apps=()
    apps=($(_validate_apps "${all_apps[@]}"))
    return_code=$?

    local appfilepath
    for app in "${apps[@]}"; do

        if [ -f "$HOME/.config/sdd/apps/$app" ]; then
            printf 'Custom installation for "%s" found.\n' "$app"
        fi

        local version
        # Try to parse version from arguments
        for arg in "$@"; do
            if [[ $arg = $app=* ]]; then
                version=$(echo $arg | cut -d"=" -f2)
                printf 'Specified version: %s\n' $version
                break
            fi
        done

        # If version not specified, try to read it from the app management
        # files. The custom definition takes precedence over the built-in one.
        if [ -z $version ]; then
            for dir in "$FRAMEWORKDIR/../apps/user" "$HOME/.config/sdd/apps"; do
                appfilepath="$dir/$app"

                if [ ! -f "$appfilepath" ]; then
                    continue
                fi

                unset -f sdd_fetch_latest_version 2> /dev/null || true
                source "$appfilepath"

                local version_from_file
                version_from_file=$(sdd_fetch_latest_version 2>/dev/null)
                if [ $? -eq 0 ]; then
                    version=$version_from_file
                fi
            done

            if [[ -n $version ]]; then
                printf 'Latest version available: %s\n' $version
            fi
        fi

        local stdoutlog=/tmp/sdd-install-$app.stdout
        local stderrlog=/tmp/sdd-install-$app.stderr
        local success=False

        for dir in "$FRAMEWORKDIR/../apps/user" "$HOME/.config/sdd/apps"; do
            appfilepath="$dir/$app"

            if [ ! -f "$appfilepath" ]; then
                continue
            fi

            # Cleanup current scope
            unset -f sdd_install 2> /dev/null || true
            # Source app management file
            source "$appfilepath"
            # Execute installation; tee stdout/stderr to files, see
            # https://stackoverflow.com/a/53051506
            { sdd_install $version > >(tee $stdoutlog ); } 2> >(tee $stderrlog >&2 )

            if [ $? -eq 0 ] && [ $success = False ]; then
                printf 'Installed "%s".\n' "$app"
                success=True

                # Record installed app and version (can be empty)
                echo $app=$version >> "$SDD_DATA_DIR"/apps/installed
            fi
        done

        if [ $success = False ]; then
            printf 'Error installing "%s". See above and %s.\n' "$app" "$stderrlog" >&2
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
    apps=($(_validate_apps "$@"))
    return_code=$?

    for app in "${apps[@]}"; do
        local stdoutlog=/tmp/sdd-uninstall-$app.stdout
        local stderrlog=/tmp/sdd-uninstall-$app.stderr

        # Execute uninstallation; tee stdout/stderr to files, see
        # https://stackoverflow.com/a/53051506
        { _utils_uninstall_one "$app" > >(tee $stdoutlog ); } 2> >(tee $stderrlog >&2 )

        ((return_code+=$?))
    done

    return $return_code
}

_utils_uninstall_one() {
    local app=$1
    if [ -f "$HOME/.config/sdd/apps/$app" ]; then
        printf 'Custom uninstallation for "%s" found.\n' "$app"
    fi

    local success=False

    local appfilepath
    for dir in "$FRAMEWORKDIR/../apps/user" "$HOME/.config/sdd/apps"; do
        appfilepath="$dir/$app"

        if [ ! -f "$appfilepath" ]; then
            continue
        fi

        # Cleanup current scope
        unset -f sdd_uninstall 2> /dev/null || true
        # Source app management file
        source "$appfilepath"
        sdd_uninstall

        if [ $? -eq 0 ] && [ $success = False ]; then
            printf 'Uninstalled "%s".\n' "$app"
            success=True

            if [ -f "$SDD_DATA_DIR"/apps/installed ]; then
                # Remove app install records
                sed -i "/^$app/d" "$SDD_DATA_DIR"/apps/installed
            fi
        fi
    done

    if [ $success = False ]; then
        printf 'Error uninstalling "%s". See above and %s.\n' "$app" "$stderrlog" >&2
        return_code=4
    fi

    return $return_code
}

utils_list() {
    local option=$1

    if [ "$option" = "--installed" ]; then
        if [ -f "$SDD_DATA_DIR"/apps/installed ]; then
            # List apps installed most recently by filtering unique app names first
            for app in $(cut -d"=" -f1 "$SDD_DATA_DIR"/apps/installed | sort | uniq | xargs); do
                grep "^$app=" "$SDD_DATA_DIR"/apps/installed | tail -n1
            done
        fi
    elif [ "$option" = "--available" ]; then
        ls -1 "$FRAMEWORKDIR/../apps/user"
    else
        printf 'Unknown option "%s".\n' "$option" >&2
        return 1
    fi
}

_tag_name_of_latest_github_release() {
    # Fetch tag name of latest release on GitHub
    local github_user=$1
    local repo_name=$2
    wget -qO- https://api.github.com/repos/$github_user/$repo_name/releases/latest | grep tag_name | awk '{ print $2; }' | sed 's/[",]//g'
}

_sha_of_github_master() {
    # Fetch SHA of latest commit on GitHub master branch
    local github_user=$1
    local repo_name=$2
    wget -qO- https://api.github.com/repos/$github_user/$repo_name/commits/master | grep -m1 sha | awk '{ print $2; }' | sed 's/[",]//g'
}

_name_of_latest_github_tag() {
    local github_user=$1
    local repo_name=$2
    wget -qO- https://api.github.com/repos/$github_user/$repo_name/tags | grep -m1 name | awk '{ print $2; }' | sed 's/[",]//g'
}
