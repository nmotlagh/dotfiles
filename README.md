# Dotfiles

Personal configuration files for a consistent terminal environment across Linux machines.

## What's Included

- **Bash Configuration** - Custom prompt with git integration, history management, and color support
- **Vim Setup** - Modern vim configuration with plugins via vim-plug
- **Tmux Config** - Clean tmux setup with custom keybindings and status bar
- **Aliases** - Handy shortcuts for common commands and git operations
- **Setup Script** - One-command installation via symbolic links

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles

# Run the setup script
cd ~/dotfiles
./setup.sh

# Reload your shell
source ~/.bashrc
```

## Features

### Bash (.bashrc)
- Custom colored prompt showing:
  - Username and hostname
  - Current directory
  - Git branch and dirty status
  - Last command exit code
- Smart history management (1000 entries, ignores duplicates)
- Supports machine-specific customization via `~/.bash_local`
- NVM integration for Node.js development

### Aliases (.bash_aliases)
```bash
# Safety aliases
rm='rm -i'   # Confirm before delete
cp='cp -i'   # Confirm before overwrite
mv='mv -i'   # Confirm before overwrite

# Directory listing
ll='ls -alF'  # Detailed list
la='ls -A'    # Show hidden files

# Git shortcuts
gs='git status'
ga='git add .'
gc='git commit -m'
gp='git push'
gl='git pull'

# Navigation
..='cd ..'
...='cd ../..'
```

### Vim (.vimrc)
- Dracula color scheme
- Relative line numbers
- Space as leader key
- Vi-style key mappings (`jj` to escape)
- Split navigation with Ctrl+hjkl
- Plugins via vim-plug:
  - vim-surround - Easily modify surrounding characters
  - vim-commentary - Comment/uncomment code
  - vim-gitgutter - Git diff in gutter
  - vim-airline - Enhanced status line
  - fzf.vim - Fuzzy file finder (`<leader>f`)

### Tmux (.tmux.conf)
- Prefix key changed to `Ctrl+Space`
- Intuitive pane splitting: `\` for horizontal, `-` for vertical
- Vi-style copy mode
- 256-color support
- Custom status bar with session name, user, host, and time
- 10,000 line scrollback buffer

## Prerequisites

### Required
- Bash shell
- Git

### Optional (for full functionality)
- **vim-plug** - For vim plugins. Install with:
  ```bash
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  ```
  Then run `:PlugInstall` in vim

- **tmux** - For terminal multiplexing
- **NVM** - If you develop with Node.js

## Portability

These dotfiles are designed to work across major Linux distributions (Ubuntu, Debian, Fedora, Arch, etc.). The configurations use standard bash features and gracefully handle missing optional dependencies.

## Customization

### Machine-Specific Settings
Create `~/.bash_local` for settings that shouldn't be version controlled:
```bash
# Example: Machine-specific exports or aliases
export CUSTOM_VAR="value"
alias work='cd ~/specific-project'
```

### Updating
Since setup.sh creates symbolic links, any changes you make to files in `~/dotfiles/` immediately take effect. Just reload your shell or source the config files.

## File Structure

```
.
├── .bash_aliases      # Command aliases
├── .bash_profile      # Login shell configuration
├── .bashrc            # Interactive shell configuration
├── .helpful_commands  # Personal command notes
├── .tmux.conf         # Tmux configuration
├── .vim/              # Vim runtime files
├── .vimrc             # Vim configuration
├── setup.sh           # Installation script
└── README.md          # This file
```

## How It Works

The `setup.sh` script creates symbolic links from your home directory to the files in this repository. This means:

1. Your configs are version controlled
2. Changes sync across machines via git
3. Updates to the repo immediately affect your environment
4. Easy to backup and restore

## License

Free to use and modify for personal or educational purposes.
