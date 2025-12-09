# Get the directory where this script is located (the dotfiles repo root)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DotfilesRoot = $ScriptDir

# Define all symlinks to create
$Symlinks = @(
    @{
        Path = $PROFILE
        Target = "$DotfilesRoot\Microsoft.PowerShell_profile.ps1"
        Description = "PowerShell profile"
    },
    @{
        Path = "$env:USERPROFILE\.gitconfig"
        Target = "$DotfilesRoot\.gitconfig"
        Description = "Git configuration"
    },
    @{
        Path = "$env:USERPROFILE\.ideavimrc"
        Target = "$DotfilesRoot\.ideavimrc"
        Description = "IdeaVim configuration"
    },
    @{
        Path = "$env:LOCALAPPDATA\nvim"
        Target = "$DotfilesRoot\nvim"
        Description = "Neovim configuration"
    },
    @{
        Path = "$env:LOCALAPPDATA\Microsoft\Windows Terminal\Fragments\dotfiles"
        Target = "$DotfilesRoot\WindowsTerminal\fragments"
        Description = "Windows Terminal fragments"
    },
    @{
        Path = "$env:USERPROFILE\CLUADE.md"
        Target = "$DotfilesRoot\CLUADE.md"
        Description = "CLUADE.md"
    }
)

Write-Host "`nCreating symlinks for Windows configurations...`n" -ForegroundColor Cyan

# Create all symlinks
foreach ($Link in $Symlinks) {
    try {
        # Remove existing symlink or file if it exists
        if (Test-Path $Link.Path) {
            Remove-Item -Path $Link.Path -Force -ErrorAction Stop
        }

        # Create the symlink
        New-Item -ItemType SymbolicLink -Path $Link.Path -Target $Link.Target -Force -ErrorAction Stop | Out-Null
        Write-Host "✓ Symlinked: $($Link.Description)" -ForegroundColor Green
        Write-Host "  $($Link.Target) -> $($Link.Path)" -ForegroundColor Gray
    }
    catch {
        Write-Host "✗ Failed to symlink: $($Link.Description)" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
    }
}

# Symlink AutoHotkey scripts to Startup folder
$AutoHotkeyDir = Join-Path $DotfilesRoot "..\AutoHotkey"
if (Test-Path $AutoHotkeyDir) {
    $StartupFolder = [Environment]::GetFolderPath('Startup')
    Write-Host "`nCreating AutoHotkey symlinks to Startup folder...`n" -ForegroundColor Cyan

    Get-ChildItem $AutoHotkeyDir -Filter *.ahk | ForEach-Object {
        $LinkPath = Join-Path $StartupFolder $_.Name
        try {
            if (Test-Path $LinkPath) {
                Remove-Item -Path $LinkPath -Force -ErrorAction Stop
            }
            New-Item -ItemType SymbolicLink -Path $LinkPath -Target $_.FullName -Force -ErrorAction Stop | Out-Null
            Write-Host "✓ Symlinked: $($_.Name)" -ForegroundColor Green
            Write-Host "  $($_.FullName) -> $LinkPath" -ForegroundColor Gray
        }
        catch {
            Write-Host "✗ Failed to symlink: $($_.Name)" -ForegroundColor Red
            Write-Host "  Error: $_" -ForegroundColor Red
        }
    }
}

Write-Host "`n✓ Done!`n" -ForegroundColor Green
