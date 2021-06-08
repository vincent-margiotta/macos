#!/usr/bin/env bash

HOMEBREW_BOOTSTRAP_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

GIT=$(command -v git) || { echo "Missing dependency: git"; exit 1; }
CURL=$(command -v curl) || { echo "Missing dependency: curl"; exit 1; }

HOMEBREW_LIBRARY="/usr/local/Homebrew/Library/Taps/homebrew"
HOMEBREW=$(command -v brew) || {
  echo "Missing dependency: homebrew"
  $(command -v bash) -c "$($CURL -fsSL $HOMEBREW_BOOTSTRAP_URL)"
  "$GIT" -C "$HOMEBREW_LIBRARY/homebrew-core" fetch --unshallow
  "$GIT" -C "$HOMEBREW_LIBRARY/homebrew-cask" fetch --unshallow
}

INSTALLED_FORMULAE=$($HOMEBREW list -1 --formulae)
MISSING_FORMULAE=$(grep -vf <(echo "$INSTALLED_FORMULAE") <(cat formulae.txt))
while read -r FORMULA; do
  [[ "$(echo "$FORMULA" | cut -c1)" == "#" ]] && continue
  echo "Install: $FORMULA" && "$HOMEBREW" install --quiet "$FORMULA"
done <<< "$MISSING_FORMULAE"

INSTALLED_CASKS=$($HOMEBREW list -1 --casks)
MISSING_CASKS=$(grep -vf <(echo "$INSTALLED_CASKS") <(cat casks.txt))
while read -r CASK; do
  [[ "$(echo "$CASK" | cut -c1)" == "#" ]] && continue
  echo "Install: $CASK" && "$HOMEBREW" install --quiet --cask "$CASK"
done <<< "$MISSING_CASKS"
