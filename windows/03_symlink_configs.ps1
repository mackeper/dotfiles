$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Win = Split-Path -Parent $MyInvocation.MyCommand.Path

# New-Item -ItemType SymbolicLink -Path $PROFILE -Target "$Win\Microsoft.PowerShell_profile.ps1" -Force
# New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gitconfig" -Target "$Root\.gitconfig" -Force
# New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.ideavimrc" -Target "$Root\.ideavimrc" -Force
# New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$Root\nvim" -Force
# New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Microsoft\Windows Terminal\Fragments\dotfiles" -Target "$Win\WindowsTerminal\fragments" -Force
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Code\User\settings.json" -Target "$Win\vscode\settings.json" -Force
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Code\User\keybindings.json" -Target "$Win\vscode\keybindings.json" -Force
