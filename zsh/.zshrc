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
