# File: ~/.bash_functions

# Activate venv in current or parent directory
venv() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.venv" ]]; then
            source "$dir/.venv/bin/activate"
            return 0
        elif [[ -d "$dir/venv" ]]; then
            source "$dir/venv/bin/activate"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    echo "No .venv or venv directory found"
    return 1
}

# Find large files (default: >100M)
findlarge() {
    find . -type f -size +${1:-100M} -exec ls -lh {} \; 2>/dev/null | awk '{ print $5 ": " $9 }'
}

# Quick experiment directory setup
expsetup() {
    mkdir -p "$1"/{data,outputs,configs,scripts,notebooks}
    echo "Created experiment structure in $1/"
}
