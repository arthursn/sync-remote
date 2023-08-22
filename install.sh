#!/bin/sh

[ -z ${INSTALL_DIR+x} ] && INSTALL_DIR="$HOME/.local/bin"

install() {
    install_dir="$1"
    echo "Installing sync-remote in '$install_dir'"

    if [ ! -d "$install_dir" ]; then
        echo "Creating installation directory '$install_dir'"
        mkdir -p "$install_dir"
    fi

    target="$install_dir/sync-remote"
    if [ -f "$target" ]; then
        while true; do
            read -p "sync-remote found in '$install_dir'. Do you wish to override the current installation? (y/n) " yn
            case $yn in
            [Yy]*)
                break
                ;;
            [Nn]*) exit ;;
            *) echo "Please answer yes or no." ;;
            esac
        done
    fi

    wget https://raw.githubusercontent.com/arthursn/sync-remote/master/sync-remote.sh -O "$target"
    chmod +x "$target"

    echo "Installation finished!"
}

install "$INSTALL_DIR"
