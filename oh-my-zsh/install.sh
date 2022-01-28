#!/usr/bin/env sh


CURL=$(command -v curl) || { echo "Missing dependency: curl"; exit 1; }

OH_MY_ZSH_BOOTSTRAP_URL="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

[ -d "$HOME/.oh-my-zsh" ] || {
  echo "Missing dependency: Oh-My-Zsh"
  $(command -v bash) -c "$($CURL -fsSL $OH_MY_ZSH_BOOTSTRAP_URL)"
}
