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
    upgrade
    uninstall
    list

General options:
    --help          Display help message
    --version       Display version information

Options for list command:
    --installed     List installed apps
    --available     List apps available for installation
    --upgradable    List apps that can be upgraded

END_OF_HELP_TEXT
}

utils_version() {
    # Publish version of present sdd installation to stdout
    if [ ! -e "$SDD_DATA_DIR"/apps/installed ]; then
        printf 'Cannot find %s.\n' "$SDD_DATA_DIR"/apps/installed >&2
        return 1;
    fi

    tac "$SDD_DATA_DIR"/apps/installed | grep -m 1 '^sdd=' | cut -d '=' -f2
}

_validate_apps() {
    # Check whether management files for specified apps are available
    # Publish valid apps/appvers to stdout
    # Args: APP[=VERSION] [APP[=VERSION]] ...

    local return_code=0
    local appfilepath app nr_misses
    local valid_appvers=()

    for appver in "$@"; do
        app=$(_get_app_name "$appver")

        nr_misses=0

        for dir in "$FRAMEWORKDIR/../apps/user" "$HOME/.config/sdd/apps"; do
            appfilepath="$dir/$app"

            if [ ! -f "$appfilepath" ]; then
                ((nr_misses++))
            fi
        done

        if [ $nr_misses -eq 2 ]; then
            printf 'App "%s" could not be found.\n' "$app" >&2
            return_code=2
        else
            valid_appvers+=($appver)
        fi
    done

    echo ${valid_appvers[@]}
    return $return_code
}

utils_install() {
    # Install one or more apps
    # Args: APP[=VERSION] [APP[=VERSION]] ...
    _manage_apps install "$@"
}

utils_uninstall() {
    # Uninstall one or more apps
    # Args: APP[=VERSION] [APP[=VERSION]] ...
    _manage_apps uninstall "$@"
}

utils_upgrade() {
    # Upgrade one or more apps
    # Args: APP[=VERSION] [APP[=VERSION]] ...
    _manage_apps upgrade "$@"
}

_manage_apps() {
    # Manage one or more apps
    # Args: METHOD APP[=VERSION] [APP[=VERSION]] ...
    local return_code=0

    local manage
    manage="$1"
    shift

    if [ $# -eq 0 ]; then
        printf 'Specify at least one app to %s.\n' "$manage" >&2
        return 1
    fi

    local appvers=()
    appvers=($(_validate_apps "$@"))
    return_code=$?

    local app stdoutlog stderrlog rclog
    rclog=/tmp/sdd-manage.rc

    for appver in "${appvers[@]}"; do
        app=$(_get_app_name "$appver")

        stdoutlog=/tmp/sdd-$manage-$app.stdout
        stderrlog=/tmp/sdd-$manage-$app.stderr

        # Invoke management function. If failed, track return code in file.
        # Redirect both stderr and stdout to log files (from
        # https://stackoverflow.com/a/59435204/3865876)
        rm -f $rclog
        { { _"$manage"_single_app "$appver" || echo $? > $rclog;} 3>&1 1>&2 2>&3- | tee "$stderrlog";} 3>&1 1>&2 2>&3- | tee "$stdoutlog"

        if [ -e $rclog ]; then
            printf 'Failed to %s "%s". See above and %s.\n' "$manage" "$app" "$stderrlog" > >(tee -a "$stderrlog" >&2 )

            ((return_code+=$(cat $rclog)))
        fi
    done

    return $return_code
}

_install_single_app() {
    # Install single, valid app
    # Args: APP[=VERSION]
    local return_code=0

    local appver="$1"
    local app
    app=$(_get_app_name "$appver")

    if [ -f "$HOME/.config/sdd/apps/$app" ]; then
        printf 'Custom installation for "%s" found.\n' "$app" >&2
    fi

    local version
    # Try to parse version from arguments
    if [[ $appver = $app=* ]]; then
        version=$(_get_app_version_from_appver "$appver")
        printf 'Specified version: %s\n' $version >&2
    fi

    # If version not specified, try to read it from the app management files.
    if [ -z $version ]; then
        version=$(_get_app_version_from_files "$app")

        if [[ -n $version ]]; then
            printf 'Latest version available: %s\n' $version >&2
        fi
    fi

    local success=False

    local appfilepath
    for dir in "$FRAMEWORKDIR/../apps/user" "$HOME/.config/sdd/apps"; do
        appfilepath="$dir/$app"

        if [ ! -f "$appfilepath" ]; then
            continue
        fi

        # Cleanup current scope
        unset -f sdd_install 2> /dev/null || true
        # Source app management file
        source "$appfilepath"
        sdd_install $version

        if [ $? -eq 0 ] && [ $success = False ]; then
            printf 'Installed "%s".\n' "$app" >&2
            success=True

            # Record installed app and version (can be empty)
            echo $app=$version >> "$SDD_DATA_DIR"/apps/installed
        fi
    done

    if [ $success = False ]; then
        return_code=4
    fi

    return $return_code
}

_uninstall_single_app() {
    # Uninstall single, valid app
    # Args: APP[=VERSION]
    local return_code=0

    local appver="$1"
    local app
    app=$(_get_app_name "$appver")

    if [ -f "$HOME/.config/sdd/apps/$app" ]; then
        printf 'Custom uninstallation for "%s" found.\n' "$app" >&2
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
            printf 'Uninstalled "%s".\n' "$app" >&2
            success=True

            if [ -f "$SDD_DATA_DIR"/apps/installed ]; then
                # Remove app install records
                sed -i "/^$app/d" "$SDD_DATA_DIR"/apps/installed
            fi
        fi
    done

    if [ $success = False ]; then
        return_code=8
    fi

    return $return_code
}

_upgrade_single_app() {
    # Upgrade single, valid app
    # Args: APP[=VERSION]

    local appver="$1"
    local app return_code
    app=$(_get_app_name "$appver")

    _uninstall_single_app "$app"
    return_code=$?

    if [ $return_code -eq 0 ]; then
        _install_single_app "$appver"
        return_code=$?
    fi

    if [ $return_code -eq 0 ]; then
        printf 'Upgraded "%s".\n' "$app" >&2
    fi

    return $return_code
}

_get_app_version_from_files() {
    # Determine relevant version of app from app management files by executing
    # the sdd_fetch_latest_version() functions.
    # The custom definition takes precedence over the built-in one.
    local app="$1"
    local appfilepath version version_from_file

    for dir in "$FRAMEWORKDIR/../apps/user" "$HOME/.config/sdd/apps"; do
        appfilepath="$dir/$app"

        if [ ! -f "$appfilepath" ]; then
            continue
        fi

        unset -f sdd_fetch_latest_version 2> /dev/null || true
        source "$appfilepath"

        version_from_file=$(sdd_fetch_latest_version 2>/dev/null)
        if [ $? -eq 0 ]; then
            version=$version_from_file
        fi
    done

    echo "$version"
}

utils_list() {
    # List apps of various kinds
    # ARGS: OPTION
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
    elif [ "$option" = "--upgradable" ]; then
        local name installed_version newest_version

        for name_version in $(utils_list --installed | xargs); do
            name=$(_get_app_name "$name_version")
            installed_version=$(_get_app_version_from_appver "$name_version")
            newest_version=$(_get_app_version_from_files "$name")

            if [[ "$installed_version" != "$newest_version" ]]; then
                printf '%s (%s -> %s)\n' "$name" "$installed_version" "$newest_version"
            fi
        done
    else
        printf 'Unknown option "%s".\n' "$option" >&2
        return 1
    fi
}

_get_app_name() {
    # Separate app name from an app=version tuple
    # E.g. with input 'foo=1.0.0' the function publishes 'foo'
    echo "$1" | cut -d"=" -f1
}

_get_app_version_from_appver() {
    # Separate app version from an app=version tuple
    # E.g. with input 'foo=1.0.0' the function publishes '1.0.0'
    echo "$1" | cut -d"=" -f2
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
