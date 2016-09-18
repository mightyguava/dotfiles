[[ -z "$PS1" ]] && return # Do nothing for a non-interactive shell

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
autoload -Uz promptinit
promptinit
# End of lines added by compinstall

# Configure history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
setopt appendhistory autocd nomatch

# Enable vim bindings and lower ESC timeout to 0.1s
bindkey -v
export KEYTIMEOUT=1

# Configure key bindings
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history
# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
# ctrl-w removed word backwards
bindkey '^w' backward-kill-word
# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

if [[ -e ~/.aliases ]]
then
  source ~/.aliases
fi

if ! which ec2metadata > /dev/null; then
  # Local mac
  export CREDENTIALS_FILE=${HOME}/credentials
else
  # EC2
  export CREDENTIALS_FILE=/etc/credentials
  if [[ -o login ]]; then
    eval `ssh-agent`
    ssh-add ~/.ssh/id_rsa
  fi
fi

if [[ -e ~/.git-prompt.sh ]]; then
  source ~/.git-prompt.sh
fi

# Enable terminal color on OSX
export CLICOLOR=1
# Configure prompt
autoload -Uz colors && colors
setopt PROMPT_SUBST
PS1='%{$fg_bold[green]%}%n@%{$fg_bold[yellow]%}%m%{$reset_color$fg_bold[magenta]%}$(__git_ps1 " (%s)")%{$reset_color%} %{$fg_bold[blue]%}%~%{$reset_color$fg_bold[red]%}%(?.. [%?] )%{$reset_color%}> '

# Show [NORMAL] in right prompt if in VI command edit mode
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [NORMAL]  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

if [[ -z $_ZSHRC_AUTO_SUGGESTIONS_SOURCED ]]; then
  # Prevent zsh-syntax-highlighting and zsh-autosuggestions from being sourced twice
  # when running "source ~/.zshrc" from the shell.
  # See https://github.com/zsh-users/zsh-autosuggestions/issues/166
  [[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
      source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
      source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  export _ZSHRC_AUTO_SUGGESTIONS_SOURCED=1
fi

