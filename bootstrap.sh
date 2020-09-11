#!/usr/bin/env bash


##
# Installation requirements
INSTALLATION_FILE="$HOME/.installed"

__complete_installation() {
  touch "$INSTALLATION_FILE"
}

__check_for_previous_installation() {
  [ -f "$INSTALLATION_FILE" ] && { echo "Install complete. Doing nothing."; exit 2; }
}


##
# Dependencies & executables

# Detect and output the path of the `homebrew` binary or outputs a friendly message.
__check_git() {
  command -v git || { echo "Dependency not found: git"; exit 1; }
}

# Detect and output the path of the `homebrew` binary or outputs a friendly message.
__check_ruby() {
  command -v ruby || { echo "Dependency not found: ruby"; exit 1; }
}

# Detect and output the path of the `homebrew` binary or outputs a friendly message.
__check_curl() {
  command -v curl || { echo "Dependency not found: curl"; exit 1; }
}

# Exit with error code `1` unless all dependencies are satisfied.
__verify_dependencies() {
  __check_git && __check_ruby && __check_curl
}

__RUBY() {
  command ruby "$@"
}

__ruby_script() {
  ( [ -z "$@" ] && return ) || __RUBY -e "$@"
}

__CURL() {
  command curl "$@"
}

__curl_url() {
  ( [ -z "$1" ] && return ) || __CURL -fsSL "$1"
}

__GIT() {
  command git "$@"
}

__git_clone() {
  ( [ -z "$*" ] && return ) || __GIT clone "$@"
}



##
# Homebrew - Package manager for macos.
#
# Offers several library functions to accomplish install homebrew itself plus
# its notion of packages-- formulae and casks-- from files.
HOMEBREW_BOOTSTRAP_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"

# Detect and output the path of the `homebrew` binary or outputs a friendly message.
__check_homebrew() {
  command -v brew || { echo "Install: homebrew"; __install_homebrew; }
}

# References the homebrew binary by its absolute path.
__HOMEBREW() {
  command brew "$@"
}

##
# Warning: The Ruby Homebrew installer is now deprecated and has been rewritten in
# Bash. Please migrate to the following command:
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
__install_homebrew() {
  __ruby_script "$( __curl_url "$HOMEBREW_BOOTSTRAP_URL" )"
}

# Homebew install a formula by name.
# Ignores any formula that starts with '#'. Supports multiple formulae per line.
__homebrew_install_formula() {
  # Detect and bail on comments
  [[ "$(echo "$@" | cut -c1)" == "#" ]] && return
  ( [ "$#" -eq 0 ] && return ) || __HOMEBREW install "$@"
}

# Homebrew install all formulae found in $FORMULAE_FILE.
# Supports both one-per-line and single line specifications.
# If no filename is provided, defaults to `formulae.txt`.
__homebrew_install_formulae() {
  FORMULAE_FILE="${1:-formulae.txt}"

  while read -r FORMULA; do
    __homebrew_install_formula "$FORMULA"
  done <<< "$(cat "$FORMULAE_FILE")"
}

# Homebrew install a cask by name.
# Ignores any cask that starts with '#'. Supports multiple casks per line.
__homebrew_install_cask() {
  [[ "$(echo "$@" | cut -c1)" == "#" ]] && return
  ( [ "$#" -eq 0 ] && return ) || __HOMEBREW cask install "$@"
}

# Homebrew install all casks found in "$CASKS_FILE".
# Supports both one-per-line and single line specifications.
# If no filename is provided, defaults to `casks.txt`.
__homebrew_install_casks() {
  CASKS_FILE="${1:-casks.txt}"

  while read -r CASK; do
    __homebrew_install_cask "$CASK"
  done <<< "$(cat "$CASKS_FILE")"
}


##
# Z-shell
OH_MY_ZSH_BOOTSTRAP_URL="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

__install_oh_my_zsh() {
  [ -d "$HOME"/.oh-my-zsh ] || $SHELL -c "$(__curl_url $OH_MY_ZSH_BOOTSTRAP_URL)"
}


##
# Vim & Vundle

VUNDLE_LOCAL="$HOME/.vim/bundle/Vundle.vim"
VUNDLE_REPOSITORY="https://github.com/VundleVim/Vundle.vim.git"

__check_vim() {
  command -v vim || { echo "Dependency not found: vim"; exit 1; }
}

__VIM() {
  command vim -u "$HOME/.vimrc-vundle" "$@"
}

__vim_run() {
  ( [ -z "$*" ] && return ) || __VIM "$@"
}

__install_vundle() {
 [ -d "$VUNDLE_LOCAL" ] || __git_clone "$VUNDLE_REPOSITORY" "$VUNDLE_LOCAL"
}

__vundle_install_plugins() {
  __vim_run +PluginInstall +qall
}

