# File: ~/.bash_aliases

# Safer deletes
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Directory listing
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'

# Git shortcuts
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Misc
alias h='history'
alias c='clear'
alias v='vim'

# Python/ML shortcuts
alias py='python3'
alias jl='jupyter lab'
alias jn='jupyter notebook'

# GPU monitoring
alias gpus='nvidia-smi'
alias gpuwatch='watch -n 1 nvidia-smi'

# Quick navigation
alias res='cd ~/research'
alias data='cd ~/datasets'

# Disk space helpers
alias duu='du -h --max-depth=1 | sort -hr'
alias dff='df -h | grep -v tmpfs'

# Process search
alias psg='ps aux | grep -v grep | grep -i'

# Tmux
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new -s'

# Tools
alias yolo='claude --dangerously-skip-permissions'
