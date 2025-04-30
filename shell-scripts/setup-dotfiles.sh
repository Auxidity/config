#!/bin/bash

set -e

USER_HOME=$1

if [ ! -d "$USER_HOME/dotfiles" ]; then
    git clone https://github.com/Auxidity/config "$USER_HOME/dotfiles"
fi

mkdir -p "$USER_HOME/.config/nvim"
cp -r "$USER_HOME/dotfiles/nvim/"* "$USER_HOME/.config/nvim/"

chown -R "$(whoami)":"$(whoami)" "$USER_HOME/.config/nvim/"

cp "$USER_HOME/dotfiles/.tmux.conf" "$USER_HOME/.tmux.conf"
chown -R "$(whoami)":"$(whoami)" "$USER_HOME/.tmux.conf"

echo Dotfiles copied!

