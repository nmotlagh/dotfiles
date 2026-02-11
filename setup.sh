#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

blue="\033[38;5;39m"
green="\033[38;5;70m"
dim="\033[38;5;245m"
reset="\033[0m"

info()  { printf "${blue}::${reset} %s\n" "$1"; }
ok()    { printf "${green} ✓${reset} %s\n" "$1"; }

FILES=(
    .bashrc
    .bash_aliases
    .bash_functions
    .bash_profile
    .vimrc
    .tmux.conf
    .gitconfig
    .helpful_commands
)

DIRS=(.vim)

# Backup existing files (only real files, not existing symlinks to us)
info "Checking for existing files to back up..."
needs_backup=false
for f in "${FILES[@]}" "${DIRS[@]}"; do
    target="$HOME/$f"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        needs_backup=true
        break
    fi
done

if $needs_backup; then
    mkdir -p "$BACKUP_DIR"
    for f in "${FILES[@]}" "${DIRS[@]}"; do
        target="$HOME/$f"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            mv "$target" "$BACKUP_DIR/"
            ok "Backed up $f → $BACKUP_DIR/"
        fi
    done
fi

# Create symlinks
info "Linking dotfiles..."
for f in "${FILES[@]}"; do
    ln -sf "$DOTFILES_DIR/$f" "$HOME/$f"
    ok "Linked $f"
done
for d in "${DIRS[@]}"; do
    ln -snf "$DOTFILES_DIR/$d" "$HOME/$d"
    ok "Linked $d/"
done

# Claude Code config
CLAUDE_FILES=(
    .claude/CLAUDE.md
    .claude/settings.json
    .claude/skills/codex/SKILL.md
)

info "Linking Claude Code config..."
for f in "${CLAUDE_FILES[@]}"; do
    target="$HOME/$f"
    source="$DOTFILES_DIR/$f"
    if [ -f "$source" ]; then
        # Backup existing file if it's not already a symlink
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            mkdir -p "$BACKUP_DIR/$(dirname "$f")"
            mv "$target" "$BACKUP_DIR/$f"
            ok "Backed up $f → $BACKUP_DIR/"
        fi
        mkdir -p "$(dirname "$target")"
        ln -sf "$source" "$target"
        ok "Linked $f"
    fi
done

# Install vim-plug if missing
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    info "Installing vim-plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null
    ok "vim-plug installed (run :PlugInstall in vim)"
else
    ok "vim-plug already present"
fi

# Reload tmux if running
if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null; then
    tmux source-file "$HOME/.tmux.conf" 2>/dev/null && ok "Tmux config reloaded"
fi

printf "\n${green}Done!${reset} Run: ${blue}source ~/.bashrc${reset}\n"
