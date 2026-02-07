# PowerShell Profile — Windows equivalent of ~/.bashrc + ~/.bash_aliases
# Install: Copy-Item .\Microsoft.PowerShell_profile.ps1 $PROFILE

#############################
# Prompt (Git + Venv)       #
#############################

function prompt {
    $exitCode = $LASTEXITCODE
    $esc = [char]27

    # Colors (Catppuccin Mocha)
    $dim    = "$esc[38;2;127;132;156m"
    $blue   = "$esc[38;2;137;180;250m"
    $green  = "$esc[38;2;166;227;161m"
    $cyan   = "$esc[38;2;148;226;213m"
    $yellow = "$esc[38;2;249;226;175m"
    $red    = "$esc[38;2;243;139;168m"
    $reset  = "$esc[0m"

    $statusColor = if ($exitCode -ne 0) { $red } else { $green }

    # Git branch
    $git = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git symbolic-ref --quiet --short HEAD 2>$null
        if (-not $branch) { $branch = git rev-parse --short HEAD 2>$null }
        if ($branch) {
            $dirty = ""
            $null = git diff --quiet --ignore-submodules --cached 2>$null
            $cachedClean = $LASTEXITCODE -eq 0
            $null = git diff --quiet --ignore-submodules 2>$null
            $workClean = $LASTEXITCODE -eq 0
            if (-not $cachedClean -or -not $workClean) { $dirty = "*" }
            $git = " (${branch}${dirty})"
        }
    }

    # Virtualenv
    $venv = ""
    if ($env:VIRTUAL_ENV) {
        $venvName = Split-Path $env:VIRTUAL_ENV -Leaf
        $venv = " ($venvName)"
    }

    $cwd = (Get-Location).Path -replace [regex]::Escape($HOME), '~'
    $user = $env:USERNAME
    $host_ = $env:COMPUTERNAME

    "${dim}[${blue}${user}@${host_}${dim}] [${green}${cwd}${dim}]${cyan}${venv}${yellow}${git}${dim} [${statusColor}${exitCode}${dim}]${reset}`n${blue}> ${reset}"
}

#############################
# Aliases — Git             #
#############################

function gs { git status @args }
function ga { git add . @args }
function gc { git commit -m @args }
function gp { git push @args }
function gl { git pull @args }

#############################
# Aliases — Navigation      #
#############################

function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

#############################
# Aliases — Common          #
#############################

Set-Alias -Name v -Value vim
Set-Alias -Name c -Value Clear-Host
Set-Alias -Name py -Value python

function ll { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force -Name @args }

#############################
# Aliases — Python / ML     #
#############################

function jl { jupyter lab @args }
function jn { jupyter notebook @args }

# Tools
function yolo { claude --dangerously-skip-permissions @args }

#############################
# Functions                 #
#############################

# Activate venv in current or parent directory (like bash venv function)
function venv {
    $dir = Get-Location
    while ($dir) {
        $dotVenv = Join-Path $dir ".venv\Scripts\Activate.ps1"
        $plainVenv = Join-Path $dir "venv\Scripts\Activate.ps1"
        if (Test-Path $dotVenv) { & $dotVenv; return }
        if (Test-Path $plainVenv) { & $plainVenv; return }
        $parent = Split-Path $dir -Parent
        if ($parent -eq $dir) { break }
        $dir = $parent
    }
    Write-Host "No .venv or venv directory found" -ForegroundColor Red
}

# Find large files (default >100MB)
function findlarge {
    param([int]$SizeMB = 100)
    Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Length -gt ($SizeMB * 1MB) } |
        Sort-Object Length -Descending |
        ForEach-Object { "{0,10:N1} MB  {1}" -f ($_.Length / 1MB), $_.FullName }
}

# Quick experiment directory setup
function expsetup {
    param([Parameter(Mandatory)][string]$Name)
    $dirs = @("data", "outputs", "configs", "scripts", "notebooks")
    foreach ($d in $dirs) { New-Item -ItemType Directory -Path (Join-Path $Name $d) -Force | Out-Null }
    Write-Host "Created experiment structure in $Name/"
}

# Quick WSL access
function wsl-here { wsl --cd (Get-Location).Path }

#############################
# Environment               #
#############################

$env:PYTHONDONTWRITEBYTECODE = "1"
$env:PYTHONUNBUFFERED = "1"

#############################
# Machine-specific (opt-in) #
#############################

$localProfile = Join-Path (Split-Path $PROFILE) "local_profile.ps1"
if (Test-Path $localProfile) { . $localProfile }
