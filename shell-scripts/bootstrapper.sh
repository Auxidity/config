#!/bin/bash
set -e 

IS_ROOT=0
if [[ "$EUID" -eq 0 ]]; then
  IS_ROOT=1
fi

if [[ $IS_ROOT -eq 1 && -n "$SUDO_USER" ]]; then
  USER_NAME="$SUDO_USER"
else
  USER_NAME="$(whoami)"
fi

USER_HOME=$(eval echo "~$USER_NAME")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running system level installations.."
chmod +x setup-neovim.sh
./setup-neovim.sh

echo "Running user setup as $USER_NAME..."
chmod +x setup-dotfiles.sh


if [[ $IS_ROOT -eq 1 && "$USER_NAME" != "root" ]]; then
  sudo -u "$USER_NAME" "$SCRIPT_DIR/setup-dotfiles.sh" "$USER_HOME"
else
  "$SCRIPT_DIR/setup-dotfiles.sh" "$USER_HOME"
fi
