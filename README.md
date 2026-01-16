# Dotfiles

Personal configuration files for bash, vim, tmux, and git.

## Setup

```bash
git clone https://github.com/nmotlagh/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
source ~/.bashrc
```

## Contents

| File | Purpose |
|------|---------|
| .bashrc | Shell configuration, prompt, environment |
| .bash_aliases | Command shortcuts |
| .bash_functions | Helper functions (venv, findlarge, expsetup) |
| .vimrc | Vim with plugins (fzf, airline, Dracula) |
| .tmux.conf | Tmux with C-Space prefix, vi-mode |
| .gitconfig | Git aliases and settings |

## Machine-Specific

Add local customizations to `~/.bash_local` (not tracked).
