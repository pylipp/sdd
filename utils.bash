mkcdir() {
    mkdir -p "$1"
    cd "$1"
}

mkcswdir() {
    mkcdir $HOME/software
}

echo_info() {
    # print output in green
    echo -e "\033[0;32m$*\033[0m"
}

echo_warn() {
    # print output in yellow
    echo -e "\033[0;33m$*\033[0m"
}

echo_error() {
    # print output in red
    echo -e "\033[0;31m$*\033[0m"
}

rm_existing() {
    if [ -e "$1" ]; then
        rm -rf "$1"
    fi
}

mv_existing() {
    if [ -e "$1" ]; then
        echo_warn "Backing up existing file $1"
        mv "$1" "$1"_old
    fi
}

install_packages() {
    for package in $@; do 
        echo_info Installing $package........................
        sudo apt-get install -y $package
        if [[ $? -ne 0 ]]; then
            echo_error "##################################################"
            echo_error "Error installing $package!"
            echo_error "##################################################"
        fi
    done 
}

echo_install_info() {
    echo_info "----------------------------------------------------------"
    echo_info "Installing $1..."
}

setup_link() {
    echo_info "Setting up link to $1..."
    ln -s ~/.files/$1 $2
}

setup_xdg_config_link() {
    # args: 
    # - application name
    # - link target file in ~/.files directory
    # - link source name in ~/.config/<application name>

    application_name="$1"
    application_config_dir=~/.config/"$application_name"

    mkdir -p "$application_config_dir"

    link_source_path="$application_config_dir"/"$3"
    mv_existing "$link_source_path"

    echo_info "Setup XDG config link for $application_name..."
    ln -s ~/.files/"$2" "$link_source_path"
}
