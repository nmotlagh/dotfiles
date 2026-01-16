# ~/.bashrc - sourced for non-login interactive shells

# Exit early if not interactive
case $- in
    *i*) ;;
    *) return ;;
esac

######################
# History Management #
######################

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000

#########################
# Window Resize Support #
#########################

shopt -s checkwinsize

#############################
# Lesspipe for non-text I/O #
#############################

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

##################################
# Prompt Customization & Colors  #
##################################

# Set chroot name if applicable
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Color prompt if terminal supports it
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes ;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 &>/dev/null; then
        color_prompt=yes
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

# Set terminal title if applicable
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
esac

#############################
# Color and Useful Aliases  #
#############################

if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

##################################
# Load Personal Aliases & Extras #
##################################

[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_functions ] && . ~/.bash_functions

#######################################
# Bash Completion (common environments)
#######################################

if ! shopt -oq posix; then
    [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
    [ -f /etc/bash_completion ] && . /etc/bash_completion
fi

##################################
# Machine-Specific Customization #
##################################

[ -f ~/.bash_local ] && . ~/.bash_local

# Set TERM for tmux
if [ -n "$TMUX" ]; then
  export TERM=tmux-256color
fi

#############################
# Python/ML Optimizations   #
#############################

export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export CUDA_DEVICE_ORDER=PCI_BUS_ID

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"
alias nvitop="uvx nvitop"
