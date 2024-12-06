# ----------------------------
# Functions
# ----------------------------
function Test-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# ----------------------------
# Fzf
# ----------------------------
if (-not (Get-Module -ListAvailable -Name PSFzf))
{
    Install-Module PSFzf
    Write-Host "PSFzf installed. Restart PowerShell to load the module."
}
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -TabExpansion
Set-PsFzfOption -EnableAliasFuzzySetLocation

# Use bat if available, otherwise use cat
if (Test-Command("bat"))
{
    $env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --border --preview "bat --style=numbers --color=always {}"'
} else
{
    $env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --border --preview "cat {}"'
}

# ----------------------------
# Terminal-Icons
# ----------------------------
if (-not (Get-Module -ListAvailable -Name Terminal-Icons))
{
    Install-Module Terminal-Icons
    Write-Host "Terminal-Icons installed. Restart PowerShell to load the module."
}
Import-Module Terminal-Icons

# ----------------------------
# posh-git
# ----------------------------
if (-not (Get-Module -ListAvailable -Name posh-git))
{
    Install-Module posh-git
    Write-Host "posh-git installed. Restart PowerShell to load the module."
}
Import-Module posh-git

# ----------------------------
# PSReadLine
# ----------------------------
if (-not (Get-Module -ListAvailable -Name PSReadLine))
{
    Install-Module PSReadLine
    Write-Host "PSReadLine installed. Restart PowerShell to load the module."
}
Import-Module PSReadLine

# https://github.com/PowerShell/PSReadLine/issues/3159
$OnViModeChange = [scriptblock]{
    if ($args[0] -eq 'Command')
    {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else
    {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PsReadLineOption -EditMode emacs
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Key Ctrl+p -ScriptBlock {
    $locations = @("D:\Documents\Projects", "D:\Documents\Software")
    $directories = $locations | ForEach-Object { Get-ChildItem -Path $_ -Directory -Depth 2 }
    $directories | Select-Object -ExpandProperty FullName | Invoke-Fzf | Set-Location
}

Set-PSReadLineKeyHandler -Key Ctrl+o -ScriptBlock {
    $locations = @("D:\Documents\Projects", "D:\Documents\Software")
    $directories = $locations | ForEach-Object { Get-ChildItem -Path $_ -Depth 2 }
    $directories | Select-Object -ExpandProperty FullName | Invoke-Fzf | Set-Location
}

Set-PSReadLineKeyHandler -Key Ctrl+s -ScriptBlock {
    $files = Get-ChildItem -Recurse -Path "*.sln" -Depth 2
    $files | Select-Object -ExpandProperty FullName | Invoke-Fzf | Invoke-Item
}

Set-PSReadLineKeyHandler -Key Ctrl+g -ScriptBlock {
    lazygit
}
