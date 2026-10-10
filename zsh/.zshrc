# Homebrew environment setup
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Shell Aliases
alias lg="lazygit"
alias cat="bat"
alias ls="eza --icons --git"
alias top="btm"
alias tmux="tmux -u"
alias tl="tmux ls"
alias ts="ta"

# Attach to an existing tmux session by name or create a new one if it doesn't exist
ta() {
  if [[ -z "$1" ]]; then
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -l 2>/dev/null || tmux list-sessions
    else
      tmux attach-session 2>/dev/null || tmux new-session
    fi
  elif [[ -n "$TMUX" ]]; then
    local session="$1"
    tmux has-session -t "$session" 2>/dev/null || tmux new-session -d -s "$session"
    tmux switch-client -t "$session"
  else
    local session="$1"
    shift
    tmux new-session -A -s "$session" "$@"
  fi
}

# Tool Integrations
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

# Agent Jail Helper (runs the isolated container sandbox)
agent-jail() {
  local container_cmd="docker"
  if command -v podman &>/dev/null; then
    container_cmd="podman"
  fi
  "$container_cmd" run -it --rm -v "$(pwd):/home/michalgr/workspace" agent-jail "$@"
}
