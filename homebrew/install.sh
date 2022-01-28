#!/usr/bin/env sh


HOMEBREW_BOOTSTRAP_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"


CURL=$(command -v curl) || { echo "Missing dependency: curl"; exit 1; }
HOMEBREW=$(command -v brew) || {
  echo "Missing dependency: homebrew"
  $(command -v sh) -c "$($CURL -fsSL $HOMEBREW_BOOTSTRAP_URL)"
  HOMEBREW=$(command -v brew) || { echo "Failed to install: homebrew"; exit 1; }
}


"$HOMEBREW" update
$(command -v xargs) "$HOMEBREW" install --formulae < "formulae.txt"
$(command -v xargs) "$HOMEBREW" install --cask < "casks.txt"
