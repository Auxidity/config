#!/bin/bash
set -e
USER_HOME="$1"
NVIM_VERSION="v0.12.2"

if command -v nvim &> /dev/null; then
    echo "Neovim already installed. Skipping."
    exit 0
fi

mkdir -p "$USER_HOME/.local/bin"
mkdir -p "$USER_HOME/.local/lib"
mkdir -p "$USER_HOME/.local/share"
mkdir -p "$USER_HOME/.config"
mkdir -p "$USER_HOME/.cache"

echo "Building Neovim $NVIM_VERSION from source..."
git clone https://github.com/neovim/neovim.git /tmp/neovim
cd /tmp/neovim
git checkout "$NVIM_VERSION"
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$USER_HOME/.local"
make install
echo "Neovim $NVIM_VERSION installed to $USER_HOME/.local/bin"
