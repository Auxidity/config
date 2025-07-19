#!/bin/bash
set -e

if command -v nvim &> /dev/null; then
	echo "Neovim already installed. Skipping build."
	exit 0
fi

echo "Neovim not found, installing dependancies and building from source..."

apt update && apt install -y ninja-build gettext cmake unzip curl build-essential git tmux xclip ripgrep fzf fd-find

# Build Neovim
git clone https://github.com/neovim/neovim.git /tmp/neovim
cd /tmp/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install

echo Neovim setup complete!
