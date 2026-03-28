#!/bin/bash

main () {
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is installed!"
        echo
    else
        echo "Homebrew is not installed! Installing now..."
        echo
        install_home_brew
    fi
}

install_home_brew () {
    echo "Running home brew installation function"
}

main "$@"; exit
