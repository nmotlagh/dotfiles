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

# Minimal git segment for the prompt.
__prompt_git() {
    command -v git >/dev/null 2>&1 || return 0
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0
    local branch
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return 0
    local dirty=""
    git diff --quiet --ignore-submodules --cached && git diff --quiet --ignore-submodules || dirty="*"
    printf " (%s%s)" "$branch" "$dirty"
}

__prompt_host="${HOSTNAME%%.*}"

__prompt_title() {
    case "$TERM" in
        xterm*|rxvt*)
            local title_path="${PWD/#$HOME/~}"
            printf '\033]0;%s\007' "${debian_chroot:+($debian_chroot)}${USER}@${__prompt_host}: ${title_path}"
            ;;
    esac
}

__prompt_set() {
    local exit_code=$?
    local reset="\[\033[0m\]"
    local dim="\[\033[38;5;245m\]"
    local blue="\[\033[38;5;39m\]"
    local green="\[\033[38;5;70m\]"
    local yellow="\[\033[38;5;214m\]"
    local red="\[\033[38;5;203m\]"
    local status_color="$green"
    if [ "$exit_code" -ne 0 ]; then
        status_color="$red"
    fi
    local chroot="${debian_chroot:+($debian_chroot) }"
    local git="$(__prompt_git)"

    PS1="${dim}${chroot}[${blue}\u@\h${dim}] [${green}\w${dim}]${yellow}${git}${dim} [${status_color}${exit_code}${dim}]\n${blue}> ${reset}"
}

if [[ "$PROMPT_COMMAND" != *"__prompt_set"* ]]; then
    if [[ -n "$PROMPT_COMMAND" ]]; then
        PROMPT_COMMAND="__prompt_title; __prompt_set; $PROMPT_COMMAND"
    else
        PROMPT_COMMAND="__prompt_title; __prompt_set"
    fi
fi

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
