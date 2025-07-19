# # # # # # #
#PERSONAL, APPEND TO THE END OF A BASHRC FILE (assuming OS comes with some aliasing)

#FZF + RIPGREP on ctrl+R
__fzf_history_search() {
  BUFFER=$(history | rg --no-line-number '' | fzf --tac +s --tiebreak=index --ansi --no-sort | sed 's/ *[0-9]* *//')
  if [[ -n "$BUFFER" ]]; then
    READLINE_LINE="$BUFFER"
    READLINE_POINT=${#BUFFER}
  fi
}

bind -x '"\C-r": __fzf_history_search'

#Direnv
eval "$(direnv hook bash)"
