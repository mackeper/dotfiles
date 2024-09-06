Import-Module posh-git
Import-Module Terminal-Icons
(@(& 'C:/Users/macke/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe' init pwsh --config='C:\Users\macke\AppData\Local\Programs\oh-my-posh\themes\jandedobbeleer.omp.json' --print) -join "`n") | Invoke-Expression

# ----------------------------------------
# --- Source files
# ----------------------------------------
$sourceFiles = @(
    "$PSSCRIPTROOT\bin_path.ps1",
    "$PSSCRIPTROOT\mimic_linux.ps1",
    "$PSSCRIPTROOT\git_aliases.ps1")

foreach ($sourceFile in $sourceFiles)
{
    if (Test-Path $sourceFile)
    {
        . $sourceFile
    } else
    {
        Write-Warning "$sourceFile not found."
    }
}

# ----------------------------------------
# --- Settings
# ----------------------------------------
Set-Variable MaximumHistoryCount 32767

# --- Aliases
# Prevent conflict with built-in aliases
function Remove-Alias ([string] $AliasName)
{
    while (Test-Path Alias:$AliasName)
    {
        Remove-Item Alias:$AliasName -Force 2> $null
    }
}
function proj
{ Set-Location D:\Documents\Projects\
}
function d
{ Set-Location D:\
}
function downloads
{ Set-Location D:\Downloads
}
function cdownloads
{ Set-Location C:\Users\macke\Downloads
}
function software
{ Set-Location D:\Documents\Software\
}

# ----------------------------------------
# Compute file hashes - useful for checking successful downloads
# ----------------------------------------
function md5
{ Get-FileHash -Algorithm MD5 $args
}
function sha1
{ Get-FileHash -Algorithm SHA1 $args
}
function sha256
{ Get-FileHash -Algorithm SHA256 $args
}


# ----------------------------------------
# --- Modules
# ----------------------------------------
if (-not (Get-Module -ListAvailable -Name PSReadLine))
{
    Install-Module PSReadLine
    Write-Host "PSReadLine installed. Restart PowerShell to load the module."
}
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -PredictionViewStyle ListView
# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# --- Fzf
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
if (Test-Path "C:\ProgramData\chocolatey\bin\bat.exe")
{
    $env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --border --preview "bat --style=numbers --color=always {}"'
} else
{
    $env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --border --preview "cat {}"'
}

class FzfCompleterAttribute : System.Management.Automation.ArgumentCompleterAttribute
{
    FzfCompleterAttribute() : base({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            $availableArguments = (git branch --format='%(refname:short)')
            if ([string]::IsNullOrWhiteSpace($wordToComplete))
            { return $availableArguments;
            }
            $availableArguments | Select-String "$wordToComplete"
        })
    {
    }
}

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

# Remove-Alias cd -Force -ErrorAction SilentlyContinue

# linux like

# --- cht.sh (https://github.com/chubin/cheat.sh)
function cht
{
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                return (Invoke-RestMethod "https://cht.sh/:list") -split "`n" | Where-Object { $_ -like "$wordToComplete*" }
            })]
        [string]$cheatsheet)
    Invoke-RestMethod cht.sh/$cheatsheet
}

# --- Git (https://github.com/gluons/powershell-git-aliases)
function gitmergecode
{ git status --porcelain | Select-String -Pattern "UU" | ForEach-Object { $_ -replace "UU ", "" } | ForEach-Object { code $_ }
}
function gitcsprojcode
{ git status --porcelain | Select-String -Pattern " M.*csproj" | ForEach-Object { $_ -replace " M ", "" } | ForEach-Object { code $_ }
}

