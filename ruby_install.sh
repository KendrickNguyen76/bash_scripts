#!/bin/bash

# Script for setting up ruby on Debian-based Linux systems
# Written on Linux Mint 22.3 (uses Ubuntu Noble)

# Variables
USER_CONSENT=false
HAS_RUBY=false

main () {
    check_for_ruby

    if $HAS_RUBY; then
        echo "You already have ruby installed;"
        ruby -v
        echo
        echo "You may want to continue with this script in order to get other important tools for ruby development."
        echo
    else
        echo "Ruby is not installed. Feel free to continue."
        echo
    fi

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
    
    echo

    install_extra_dependencies

    echo

    install_ruby
    
    # Confirm installation
    echo "Confirming that installation was a success..."
    rbenv versions
    echo

    check_for_extra_dependencies
    
    # Exit and let the user of any other steps:
    echo "Ruby is now set-up on your machine!"
    echo "For more information on rbenv, check here: https://github.com/rbenv/rbenv?tab=readme-ov-file"
}

# Functions for checking
check_for_ruby () {
    if command -v ruby >/dev/null 2>&1; then
        HAS_RUBY=true
    else
        HAS_RUBY=false
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

# Installation functions
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
    sudo apt update
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

install_extra_dependencies () {
    echo "Installing these dependencies: rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev"
    sudo apt install rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev
    echo
}

install_ruby () {
    # Install latest ruby version using rbenv
    echo "Installing ruby version 4.0.2 (Latest stable version as of March 2026)"
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr"
    rbenv install 4.0.2
    echo

    switch_to_rbenv_ver

    echo "Setting global ruby version..."
    rbenv global 4.0.2

    echo "Rehasing rbenv..."
    rbenv rehash

    echo "Checking correct ruby version is installed (should say 4.0.2)"
    ruby -v
    which ruby
    echo
}

switch_to_rbenv_ver () {
    # Switch ruby versions so that gems get installed to the 
    # rbenv version, not the system version
    echo "Setting rbenv global version as main ruby version..."
    echo >> /home/kendrick/.bashrc
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/kendrick/.bashrc
    echo 'eval "$(rbenv init - bash)"' >> /home/kendrick/.bashrc
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init - bash)"
    echo
}

check_for_extra_dependencies () {
    echo "Check for these extra dependencies: zlib1g-dev libssl-dev libreadline-dev libyaml-dev"
    echo

    ruby -rzlib -e "puts 'zlib OK'"
    ruby -ropenssl -e "puts 'openssl OK'"
    ruby -rreadline -e "puts 'readline OK'"
    ruby -ryaml -e "puts 'yaml OK'"

    echo
}

# Run main function
main "$@"; exit
