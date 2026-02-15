###############################################################################
# ZSH CONFIGURATION — Clean, Fast, Modern
# Managed via GNU Stow
###############################################################################

# ---------------------------------------------------------------------------
# Zsh options (behavior)
# ---------------------------------------------------------------------------

# Better history behavior
setopt HIST_IGNORE_ALL_DUPS      # remove older duplicate entries
setopt HIST_REDUCE_BLANKS        # remove superfluous blanks
setopt INC_APPEND_HISTORY        # write history immediately
setopt SHARE_HISTORY             # share history between sessions
setopt EXTENDED_HISTORY          # timestamp commands

# Safer globbing
setopt NO_NOMATCH                # no error if glob doesn't match

# Better directory handling
setopt AUTO_CD                   # cd by typing directory name
setopt AUTO_PUSHD                # push dirs to stack
setopt PUSHD_IGNORE_DUPS         # no duplicates in dir stack

# ---------------------------------------------------------------------------
# History configuration
# ---------------------------------------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

# ---------------------------------------------------------------------------
# Environment variables
# ---------------------------------------------------------------------------

#export EDITOR="nvim"
#export VISUAL="nvim"
export EDITOR="code -r --wait"
export VISUAL="code -r --wait"
export PAGER="less"

# Use less with sensible defaults
export LESS="-R -F -X"

# Language / locale
export LANG="en_US.UTF-8"

# ---------------------------------------------------------------------------
# PATH management
# ---------------------------------------------------------------------------

# User-local binaries
export PATH="$HOME/.local/bin:$PATH"

# Cargo (Rust)
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

# ---------------------------------------------------------------------------
# Completion system (must be early)
# ---------------------------------------------------------------------------

autoload -Uz compinit
compinit

# Better completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ---------------------------------------------------------------------------
# Keybindings
# ---------------------------------------------------------------------------

# Emacs-style keybindings (default, explicit)
bindkey -e

# Useful bindings
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^R' history-incremental-search-backward

# Home / End fixes
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# Enable proper bracketed paste handling
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# ---------------------------------------------------------------------------
# Aliases — Safe, Modern Replacements
# ---------------------------------------------------------------------------

# Safer core commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Modern replacements (installed separately)
alias ls='eza --icons --group-directories-first'
alias la='ls -a'
alias ll='eza -lah --icons --group-directories-first'
alias tree='eza --tree --icons'

alias cat='bat'
alias grep='rg'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Tmux
alias t='tmux'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux ls'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'

alias h='history'
alias hg='history | grep'

alias editrc="code -r ~/.zshrc"
alias editlocalrc="code -r ~/.zshrc.local"

# ---------------------------------------------------------------------------
# Functions (small, useful helpers)
# ---------------------------------------------------------------------------

# Create directory and enter it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Quickly extract archives
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1" ;;
      *.tar.gz)    tar xzf "$1" ;;
      *.bz2)       bunzip2 "$1" ;;
      *.rar)       unrar x "$1" ;;
      *.gz)        gunzip "$1" ;;
      *.tar)       tar xf "$1" ;;
      *.tbz2)      tar xjf "$1" ;;
      *.tgz)       tar xzf "$1" ;;
      *.zip)       unzip "$1" ;;
      *.Z)         uncompress "$1" ;;
      *.7z)        7z x "$1" ;;
      *)           echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ---------------------------------------------------------------------------
# fzf integration (if installed)
# ---------------------------------------------------------------------------

if command -v fzf >/dev/null 2>&1; then
  # Default fzf options
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

  # Use fd if available
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  fi

  # Keybindings & completion
  source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
  source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null
fi

# ---------------------------------------------------------------------------
# zoxide — smarter cd replacement
# ---------------------------------------------------------------------------

if command -v zoxide >/dev/null 2>&1; then
  # Initialize zoxide for zsh
  # Provides: z, zi, and directory ranking
  eval "$(zoxide init zsh)"
fi

# ---------------------------------------------------------------------------
# Starship prompt (last, after everything else)
# ---------------------------------------------------------------------------

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

###############################################################################
# Local (machine-specific) overrides
# This file is NOT tracked in git
###############################################################################

if [[ -f "${HOME}/.zshrc.local" ]]; then
  source "${HOME}/.zshrc.local"
fi

###############################################################################
# Mammouth Code
###############################################################################
if [[ -x "$HOME/.mammouth/bin/mammouth" ]]; then
  export PATH="$HOME/.mammouth/bin:$PATH"

  #compdef mammouth
  _mammouth_yargs_completions()
  {
    local reply
    local si=$IFS
    IFS=$'
  ' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" mammouth --get-yargs-completions "${words[@]}"))
    IFS=$si
    if [[ ${#reply} -gt 0 ]]; then
      _describe 'values' reply
    else
      _default
    fi
  }
  if [[ "'${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
    _mammouth_yargs_completions "$@"
  else
    compdef _mammouth_yargs_completions mammouth
  fi
  ###-end-mammouth-completions-###
fi

###############################################################################
# End of .zshrc
###############################################################################
