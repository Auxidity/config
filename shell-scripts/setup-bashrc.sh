#!/bin/bash
# setup-bashrc.sh - runs as user
set -e
USER_HOME="$1"
BASHRC="$USER_HOME/.bashrc"

# create .bashrc if it doesn't exist (bare containers)
touch "$BASHRC"

if grep -qF "#PERSONAL" "$BASHRC"; then
    echo ".bashrc already configured, skipping."
    exit 0
fi

echo "Appending personal config to .bashrc..."
cat >> "$BASHRC" << 'EOF'

#PERSONAL
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

#FZF + RIPGREP on ctrl+R
__fzf_history_search() {
  BUFFER=$(history | rg --no-line-number '' | fzf --tac +s --tiebreak=index --ansi --no-sort | sed 's/ *[0-9]* *//')
  if [[ -n "$BUFFER" ]]; then
    READLINE_LINE="$BUFFER"
    READLINE_POINT=${#BUFFER}
  fi
}
bind -x '"\C-r": __fzf_history_search'
eval "$(direnv hook bash)"
EOF

echo "Done."
