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

# Enable git completions
zstyle ':completion:*:*:git:*' script ~/.git-completion.bash
if [[ -f ~/.zsh/.git-completion.zsh ]]; then
  fpath=(~/.zsh $fpath)
fi

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
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
# Linux colors
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
# Use Linux-flavor colors for zsh ls completion
zstyle ':completion:*:default' list-colors "${LS_COLORS}"

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

# FZF completions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=~/scripts:~/bin:${PATH}

# Source local custom zshrc
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
