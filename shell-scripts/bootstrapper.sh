#!/bin/bash
set -e 

USER_NAME=${SUDO_USER:$(whoami)}
USER_HOME=$(eval echo "~$USER_NAME")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running system level installations.."
chmod +x setup-neovim.sh
./setup-neovim.sh

echo "Running user setup as $USER_NAME..."
chmod +x setup-dotfiles.sh
sudo -u "$USER_NAME" "$SCRIPT_DIR/setup-dotfiles.sh" "$USER_HOME"
