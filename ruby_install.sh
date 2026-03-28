#!/bin/bash

# Script for setting up ruby on Debian-based Linux systems
# Written on Linux Mint 22.3 (uses Ubuntu Noble)

main () {
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is installed!"
        echo "Using this version of Homebrew:"
        brew --version
    else
        echo "Homebrew is not installed! Installing now..."
        echo
        install_home_brew
    fi



}

install_home_brew () {
    # Based off of instructions from this website: https://brew.sh/
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add homebrew to path
    echo "Adding Homebrew to Path..."
    echo >> /home/kendrick/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /home/kendrick/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
    echo

    # Installing dependencies (linux)
    echo "Installing dependencies for Homebrew through apt-get..."
    sudo apt-get install build-essential 
    echo

    # Double check everything works
    echo "Checking if brew --version command works..."
    brew --version
}

main "$@"; exit
