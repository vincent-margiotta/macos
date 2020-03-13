#!/usr/bin/env bash

##
# Installation requirements
__installation() {
  echo "$HOME"/.installed
}

__complete_installation() {
  touch "$(__installation)"
}

__check_for_previous_installation() {
  [ -f "$(__installation)" ] && { echo "Install complete. Doing nothing."; exit 2; }
}

__RUBY() {
  command -v ruby || { echo "Dependency not found: ruby"; exit 1; }
}

__CURL() {
  command -v curl || { echo "Dependency not found: curl"; exit 1; }
}

__curl_url() {
  ( [ -z "$1" ] && return ) || $(__CURL) -fsSL "$1"
}

__verify_dependencies() {
  __ruby && __curl
}


##
# Homebrew related
__HOMEBREW() {
  command -v brew || { echo "Install: homebrew"; __install_homebrew; }
}

__homebrew_bootstrap_url() {
  echo "https://raw.githubusercontent.com/Homebrew/install/master/install"
}

__install_homebrew() {
  __RUBY -e "$( $(__curl) -fsSL __homebrew_bootstrap_url )"
}

__homebrew_install_formula() {
  ( [ -z "$1" ] && return ) || $( __HOMEBREW ) install "$1"
}

__homebrew_install_formulae() {
  FORMULAE_FILE="${1:-formulae.txt}"

  while read -r FORMULA; do
    __homebrew_install_formula "$FORMULA"
  done <<< "$( cat "$FORMULAE_FILE" )"
}

__homebrew_install_cask() {
  ( [ -z "$1" ] && return ) || $( __HOMEBREW ) cash install "$1"
}

__homebrew_install_casks() {
  CASKS_FILE="${1:-casks.txt}"

  while read -r CASK; do
    __homebrew_install_cask "$CASK"
  done <<< "$( cat "$CASKS_FILE" )"
}

##
# Z-shell
__oh_my_zsh_bootstrap_url() {
  "https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
}

__install_oh_my_zsh() {
  [ -d "$HOME"/.oh-my-zsh ] || $SHELL -c "$($CURL -fsSL $(__oh_my_zsh_bootstrap_url))"
}
