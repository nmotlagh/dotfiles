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

# --- Agent config (shared skills, per-tool instructions) ---

# Helper: backup a file/dir if it exists and isn't already a symlink
backup_if_needed() {
    local target="$1" backup_path="$2"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$(dirname "$backup_path")"
        mv "$target" "$backup_path"
        ok "Backed up $target → $backup_path"
    fi
}

# Claude Code: ~/.claude/CLAUDE.md
info "Linking Claude Code config..."
mkdir -p "$HOME/.claude"
backup_if_needed "$HOME/.claude/CLAUDE.md" "$BACKUP_DIR/.claude/CLAUDE.md"
ln -sf "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ok "Linked .claude/CLAUDE.md"

# Claude Code: ~/.claude/skills → dotfiles/skills
backup_if_needed "$HOME/.claude/skills" "$BACKUP_DIR/.claude/skills"
ln -snf "$DOTFILES_DIR/skills" "$HOME/.claude/skills"
ok "Linked .claude/skills/ → dotfiles/skills/"

# Codex CLI: ~/.codex/AGENTS.md
info "Linking Codex CLI config..."
mkdir -p "$HOME/.codex"
backup_if_needed "$HOME/.codex/AGENTS.md" "$BACKUP_DIR/.codex/AGENTS.md"
ln -sf "$DOTFILES_DIR/.codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
ok "Linked .codex/AGENTS.md"

# Codex CLI: symlink each skill into ~/.codex/skills/ (preserves .system/)
mkdir -p "$HOME/.codex/skills"
for skill_dir in "$DOTFILES_DIR/skills"/*/; do
    skill_name="$(basename "$skill_dir")"
    target="$HOME/.codex/skills/$skill_name"
    backup_if_needed "$target" "$BACKUP_DIR/.codex/skills/$skill_name"
    ln -snf "$skill_dir" "$target"
    ok "Linked .codex/skills/$skill_name/"
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
