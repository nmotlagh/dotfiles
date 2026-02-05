# Dotfiles

Portable configuration files for a consistent terminal environment across Linux machines.

## Quick Start

```bash
git clone git@github.com:nmotlagh/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
source ~/.bashrc
```

The setup script backs up any existing configs to `~/.dotfiles_backup/` before symlinking.

## What's Included

| File | Purpose |
|---|---|
| `.bashrc` | Interactive shell: prompt with git branch, history, color support |
| `.bash_aliases` | Shortcuts for git, navigation, GPU monitoring, tmux |
| `.bash_functions` | Helper functions: `venv`, `findlarge`, `expsetup` |
| `.bash_profile` | Login shell: sources `.bashrc`, sets up `$PATH` |
| `.vimrc` | Vim config with Dracula theme, vim-plug, airline, fzf |
| `.tmux.conf` | Tmux with Catppuccin Mocha colors, vi copy mode |
| `.gitconfig` | Git aliases, histogram diffs, LFS support |
| `setup.sh` | Symlink installer with backup and vim-plug bootstrap |

## Highlights

### Bash Prompt
- User, host, directory, git branch + dirty flag, last exit code
- Supports virtualenv display and machine-specific `~/.bash_local`

### Tmux
- **Prefix:** `Ctrl+Space`
- **Splits:** `\` horizontal, `-` vertical (open in current path)
- **Pane nav:** `h/j/k/l` (vim-style) or `Alt+Arrow` to resize
- **Copy mode:** vi-style (`Escape` to enter, `v` select, `y` yank)
- **Theme:** Catppuccin Mocha — blue session pill, green active window tab
- Mouse enabled, 10k scrollback, auto window renumber

### Vim
- Dracula color scheme, relative line numbers
- Space as leader (`jj` to escape insert mode)
- Split navigation with `Ctrl+h/j/k/l`
- Plugins: vim-surround, vim-commentary, vim-gitgutter, vim-airline, fzf.vim

### Git
- Aliases: `st`, `co`, `br`, `ci`, `visual` (graph log), `uncommit`
- Histogram diff algorithm, auto-setup remote on push

## Customization

Create `~/.bash_local` for machine-specific settings (not version controlled):

```bash
export CUSTOM_VAR="value"
alias work='cd ~/my-project'
```

## Prerequisites

- Bash, Git
- Optional: [vim-plug](https://github.com/junegunn/vim-plug) (auto-installed by `setup.sh`), tmux, NVM
