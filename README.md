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

| File / Dir | Purpose |
|---|---|
| `.bashrc` | Interactive shell: prompt with git branch, history, color support |
| `.bash_aliases` | Shortcuts for git, navigation, GPU monitoring, tmux |
| `.bash_functions` | Helper functions: `venv`, `findlarge`, `expsetup` |
| `.bash_profile` | Login shell: sources `.bashrc`, sets up `$PATH` |
| `.vimrc` | Vim config with Dracula theme, vim-plug, airline, fzf |
| `.tmux.conf` | Tmux with Catppuccin Mocha colors, vi copy mode |
| `.gitconfig` | Git aliases, histogram diffs, LFS support |
| `.claude/CLAUDE.md` | Claude Code global instructions |
| `.codex/AGENTS.md` | Codex CLI global instructions |
| `skills/` | Shared [Agent Skills](https://agentskills.io) for Claude Code and Codex CLI |
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

## Agent Skills

Skills are stored in `skills/` and symlinked into both `~/.claude/skills/` and `~/.codex/skills/` by `setup.sh`. They follow the open [Agent Skills](https://agentskills.io) standard and work across both tools.

| Skill | Invocation | What It Does |
|---|---|---|
| `compile-latex` | Auto or `/compile-latex` | Compile paper, categorize errors/warnings |
| `check-refs` | Auto or `/check-refs` | Validate `\ref{}`, `\cite{}`, `\label{}` |
| `check-tables` | Auto or `/check-tables` | Number consistency: tables vs prose |
| `acl-format-check` | Auto or `/acl-format-check` | ACL submission compliance checklist |
| `proofread-section` | `/proofread-section <file>` | Grammar, style, clarity review |
| `review-paper` | `/review-paper` | Full ACL reviewer simulation (forked context) |
| `fill-results` | `/fill-results <path>` | Update tables from experiment output |
| `codex` | `/codex` | Delegate tasks to OpenAI Codex CLI |

To add a new skill, create `skills/<name>/SKILL.md` — it will be available to both agents after running `setup.sh` (or immediately for Claude Code since `~/.claude/skills` is a direct symlink to `skills/`).

## Customization

Create `~/.bash_local` for machine-specific settings (not version controlled):

```bash
export CUSTOM_VAR="value"
alias work='cd ~/my-project'
```

## Prerequisites

- Bash, Git
- Optional: [vim-plug](https://github.com/junegunn/vim-plug) (auto-installed by `setup.sh`), tmux, NVM
