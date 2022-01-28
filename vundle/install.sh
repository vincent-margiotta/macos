#!/usr/bin/env sh


GIT=$(command -v git) || { echo "Missing dependency: git"; exit 1; }
VIM=$(command -v vim) || { echo "Missing dependency: vim"; exit 1; }

VUNDLE_LOCAL="$HOME/.vim/bundle/Vundle.vim"
VUNDLE_REPOSITORY="https://github.com/VundleVim/Vundle.vim.git"
VUNDlE_RC="$HOME/.vimrc-vundle"

[ -d "$VUNDLE_LOCAL" ] || "$GIT" clone "$VUNDLE_REPOSITORY" "$VUNDLE_LOCAL"
[ -f "$VUNDlE_RC" ] && "$VIM" -u "$VUNDlE_RC" +PluginInstall +qall
