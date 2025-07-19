#!/bin/bash
# User level installation
set -e

DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    git clone https://github.com/Auxidity/config "$DOTFILES_DIR"
fi

mkdir -p "$DOTFILES_DIR/nvim"
cp -r "$DOTFILES_DIR/nvim/"* "$HOME/.config/nvim/"

cp "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo Dotfiles copied!

