#!/bin/bash
# master.sh
set -e

if [[ "$EUID" -ne 0 ]]; then
    echo "Run as root or with sudo"
    exit 1
fi

USER_NAME="${SUDO_USER:-$(whoami)}"
USER_HOME=$(eval echo "~$USER_NAME")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing system dependencies..."
apt update && apt install -y \
    ninja-build gettext cmake unzip curl \
    build-essential git tmux xclip \
    ripgrep fzf fd-find direnv

chmod +x setup-neovim.sh # Shouldn't need to add script_dir here, but the sudo -u has sometimes failed without evaling script dir.. idk why
chmod +x setup-dotfiles.sh
chmod +x setup-bashrc.sh

echo "Running user setup as $USER_NAME..."
sudo -u "$USER_NAME" "$SCRIPT_DIR/setup-neovim.sh" "$USER_HOME"
sudo -u "$USER_NAME" "$SCRIPT_DIR/setup-dotfiles.sh" "$USER_HOME"
sudo -u "$USER_NAME" "$SCRIPT_DIR/setup-bashrc.sh" "$USER_HOME"
