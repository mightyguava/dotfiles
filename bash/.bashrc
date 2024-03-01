# If not running interactively, don't do anything
[ -z "$PS1"  ] && return

if [ -z $(which ec2metadata) ]; then
  # Local mac
  export CREDENTIALS_FILE=${HOME}/credentials
else
  # EC2
  export CREDENTIALS_FILE=/etc/credentials
fi

if [ -e ~/.bash_aliases ]
then
  source ~/.bash_aliases
fi

export PS1='\[\033[01;32m\]\u@\[\033[1;33m\]\h\[\033[35m\]$(__git_ps1)\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFG'
alias la='ls -A'
alias l='ls -CF'

if [ -e ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi
if [ -e ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

# FZF completions
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH=~/scripts:~/bin:${PATH}

# Source local custom bashrc
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

[ -f ~/Library/Preferences/org.dystroy.broot/launcher/bash/br] && source ~/Library/Preferences/org.dystroy.broot/launcher/bash/br

. "$HOME/.cargo/env"
