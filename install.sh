#!/usr/bin/env bash

source bootstrap.sh

# Fail early if the system has been previously bootstrapped
__check_for_previous_installation

# In order to bootstrap homebrew, we need cURL, ruby, and git
# to be installed:
__verify_dependencies

# Verify the Homebrew installation before continuing
__check_homebrew
__homebrew_install_formulae
__homebrew_install_casks

# Install Oh-My-Zsh
__install_oh_my_zsh

# Verify the Vim installation before continuing
__check_vim
__install_vundle
__vundle_install_plugins

# Finally, touch a simple text file to indicate the installation
# was a success ($HOME/.installed). Delete this file to reiterate
# the process.
__complete_installation
