#!/usr/bin/env sh


HOMEBREW_BOOTSTRAP_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"


CURL=$(command -v curl) || { echo "Missing dependency: curl"; exit 1; }
HOMEBREW=$(command -v brew) || {
  echo "Missing dependency: homebrew"
  $(command -v sh) -c "$($CURL -fsSL $HOMEBREW_BOOTSTRAP_URL)"
  HOMEBREW=$(command -v brew) || { echo "Failed to install: homebrew"; exit 1; }
}


"$HOMEBREW" update


# install formulae
while IFS= read -r REQUESTED; do
  # skip comments
  [ "$(echo "$REQUESTED" | cut -c1)" = "#" ] && continue
  echo "Install: $REQUESTED" && "$HOMEBREW" install --force "$REQUESTED"
done < "formulae.txt"


# Install casks
while IFS= read -r REQUESTED; do
  # skip comments
  [ "$(echo "$REQUESTED" | cut -c1)" = "#" ] && continue
  echo "Install (cask): $REQUESTED" && "$HOMEBREW" install --force --cask "$REQUESTED"
done < "casks.txt"
