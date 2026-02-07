# Windows dotfiles setup — PowerShell equivalent of setup.sh
# Run: .\setup.ps1

$ErrorActionPreference = "Stop"
$dotfilesDir = Split-Path $PSScriptRoot -Parent
$windowsDir = $PSScriptRoot

Write-Host ":: " -ForegroundColor Blue -NoNewline
Write-Host "Setting up Windows dotfiles..."

# ── PowerShell Profile ──────────────────────────────────

$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$source = Join-Path $windowsDir "Microsoft.PowerShell_profile.ps1"

if (Test-Path $PROFILE) {
    $backupDir = Join-Path $HOME ".dotfiles_backup" (Get-Date -Format "yyyyMMdd_HHmmss")
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    Copy-Item $PROFILE (Join-Path $backupDir "Microsoft.PowerShell_profile.ps1")
    Write-Host " + " -ForegroundColor Green -NoNewline
    Write-Host "Backed up existing profile to $backupDir"
}

Copy-Item $source $PROFILE -Force
Write-Host " + " -ForegroundColor Green -NoNewline
Write-Host "Installed PowerShell profile -> $PROFILE"

# ── Windows Terminal Settings ───────────────────────────

$wtSettingsPath = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$wtSource = Join-Path $windowsDir "windows-terminal.json"

if (Test-Path (Split-Path $wtSettingsPath -Parent)) {
    if (Test-Path $wtSettingsPath) {
        if (-not $backupDir) {
            $backupDir = Join-Path $HOME ".dotfiles_backup" (Get-Date -Format "yyyyMMdd_HHmmss")
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        }
        Copy-Item $wtSettingsPath (Join-Path $backupDir "windows-terminal.json")
        Write-Host " + " -ForegroundColor Green -NoNewline
        Write-Host "Backed up existing Windows Terminal settings"
    }
    Copy-Item $wtSource $wtSettingsPath -Force
    Write-Host " + " -ForegroundColor Green -NoNewline
    Write-Host "Installed Windows Terminal settings"
} else {
    Write-Host " - " -ForegroundColor Yellow -NoNewline
    Write-Host "Windows Terminal not found, skipping"
}

# ── Git Config ──────────────────────────────────────────

$gitconfigSource = Join-Path $dotfilesDir ".gitconfig"
$gitconfigTarget = Join-Path $HOME ".gitconfig"

if ((Test-Path $gitconfigTarget) -and -not (Test-Path (Join-Path $gitconfigTarget ".git"))) {
    if (-not $backupDir) {
        $backupDir = Join-Path $HOME ".dotfiles_backup" (Get-Date -Format "yyyyMMdd_HHmmss")
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    }
    Copy-Item $gitconfigTarget (Join-Path $backupDir ".gitconfig")
    Write-Host " + " -ForegroundColor Green -NoNewline
    Write-Host "Backed up existing .gitconfig"
}
Copy-Item $gitconfigSource $gitconfigTarget -Force
Write-Host " + " -ForegroundColor Green -NoNewline
Write-Host "Installed .gitconfig"

Write-Host ""
Write-Host "Done! " -ForegroundColor Green -NoNewline
Write-Host "Restart your terminal or run: " -NoNewline
Write-Host ". `$PROFILE" -ForegroundColor Blue
