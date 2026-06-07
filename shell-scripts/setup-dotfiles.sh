#!/bin/bash
# User level installation
set -e

USER_HOME="$1"
DOTFILES_DIR="$USER_HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    git clone https://github.com/Auxidity/config "$DOTFILES_DIR"
fi

mkdir -p "$USER_HOME/.config/nvim"
cp -r "$DOTFILES_DIR/nvim/"* "$USER_HOME/.config/nvim/"
cp "$DOTFILES_DIR/.tmux.conf" "$USER_HOME/.tmux.conf"

echo "Dotfiles copied!"
