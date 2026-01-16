#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
echo "Setting up dotfiles from $DOTFILES_DIR..."

# Create symlinks
ln -sf "$DOTFILES_DIR/.bashrc" ~/.bashrc
ln -sf "$DOTFILES_DIR/.bash_aliases" ~/.bash_aliases
ln -sf "$DOTFILES_DIR/.bash_functions" ~/.bash_functions
ln -sf "$DOTFILES_DIR/.bash_profile" ~/.bash_profile
ln -sf "$DOTFILES_DIR/.vimrc" ~/.vimrc
ln -sf "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES_DIR/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES_DIR/.helpful_commands" ~/.helpful_commands
ln -snf "$DOTFILES_DIR/.vim" ~/.vim

echo "Dotfiles linked successfully!"
echo "Run: source ~/.bashrc"
