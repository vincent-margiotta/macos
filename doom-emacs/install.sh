#!/usr/bin/env sh

GIT=$(command -v git) || { "Missing dependency: git"; exit 1; }
HOMEBREW=$(command -v brew) || { "Missing dependency: homebrew"; exit 1; }

DOOM_URL="https://github.com/hlissner/doom-emacs"

DOOM_DIR="$HOME/.doom.d"
EMACS_DIR="$HOME/.emacs.d"

[ -d "$DOOM_DIR" ] || {
  # Install dependencies for DOOM Emacs
  "$HOMEBREW" install git ripgrep coreutils fd
  # Install vanilla Emacs
  "$HOMEBREW" tap railwaycat/emacsmacport
  "$HOMEBREW" install --cask emacs-mac
  ln -s /usr/local/opt/emacs-mac/Emacs.app /Applications/Emacs.app
  # Install DOOM Emacs
  "$GIT" clone "$DOOM_URL" "$EMACS_DIR"
  "$EMACS_DIR"/bin/doom install
}
