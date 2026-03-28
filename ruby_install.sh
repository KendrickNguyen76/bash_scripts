#!/bin/bash

# Script for setting up ruby on Debian-based Linux systems
# Written on Linux Mint 22.3 (uses Ubuntu Noble)

# variable representing user consent to using this script
USER_CONSENT=false

main () {
    confirm_user_install

    if $USER_CONSENT; then
        echo
        echo "Starting installation process..."
        echo
    else
        echo "Exiting ruby_install.sh script..."
        exit
    fi

    # Check to see if Homebrew is installed
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is installed!"
        echo "Using this version of Homebrew:"
        brew --version
    else
        echo "Homebrew is not installed! Installing now..."
        echo
        install_home_brew
    fi

    echo

    # Check to see if rbenv and ruby build are installed
    if command -v rbenv >/dev/null 2>&1; then
        echo "rbenv is installed!"
        echo "Using this version of rbenv/ruby-build:"
        rbenv -v
        ruby-build --version
    else
        echo "rbenv is not installed! Installing now..."
        echo
        install_rbenv
    fi

}

confirm_user_install () {
    # Warn users of what will be installed
    echo "Note: This script will install the following items onto your Debian-based Linux system:"
    echo "1. Homebrew"
    echo "2. rbenv"
    echo "3. ruby-build"
    echo "4. Latest stable release of ruby"
    echo
    echo "Additional dependencies may be downloaded as well."
    echo

    while true; do
        read -p "Do you wish to run this script? (y/n) " yn
        case $yn in
            [Yy]* ) USER_CONSENT=true; break;;
            [Nn]* ) USER_CONSENT=false; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
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

install_rbenv () {
    echo "Installing rbenv..."
    brew install rbenv
    echo

    echo "Installing ruby-build..."
    brew install ruby-build
    echo

    echo "Checking if rbenv and ruby-build are installed properly..."
    rbenv -v
    ruby-build --version
}

main "$@"; exit
