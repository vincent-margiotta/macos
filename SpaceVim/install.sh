#!/usr/bin/env sh


SPACEVIM_INSTALL_URL="https://spacevim.org/install.sh"

BASH=$(command -v bash) || { echo "Missing dependency: bash"; exit 1; }
CURL=$(command -v curl) || { echo "Missing dependency: curl"; exit 1; }

[ -d "$HOME/.SpaceVim" ] || {
  "$CURL" -sLf "$SPACEVIM_INSTALL_URL" | "$BASH"
}
