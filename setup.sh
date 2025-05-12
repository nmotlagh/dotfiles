#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

ln -sf "$DOTFILES_DIR/.bashrc" ~/.bashrc
ln -sf "$DOTFILES_DIR/.vimrc" ~/.vimrc
ln -sf "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES_DIR/.helpful_commands" ~/.helpful_commands

