# --- General ---
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None

# --- Prompt ---
function prompt {
    $path = (Get-Location).Path.Replace($HOME, '~')
    $branch = ''
    $gitInfo = ''
    if (git rev-parse --is-inside-work-tree 2>$null) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        $gitInfo = & { git diff --quiet 2>$null; if ($LASTEXITCODE -eq 0) { "" } else { " $([char]27)[38;5;9m~$([char]27)[0m" } }
    }
    $display = if ($branch) { "$([char]27)[38;5;15m ($([char]27)[38;5;10m$branch$gitInfo$([char]27)[38;5;15m)" } else { "" }
    "$([char]27)[38;5;10mPS$([char]27)[0m $([char]27)[38;5;15m$path$display$([char]27)[0m > "
}

# --- PowerShell Aliases ---
Remove-Alias ls -Force -ErrorAction SilentlyContinue
function ls([string]$path = ".") {
    if (Get-Command -Name "eza" -ErrorAction SilentlyContinue) {
        eza --icons $path
    } else {
        Get-ChildItem -Exclude ".*" $path | Format-Wide -AutoSize -ErrorAction SilentlyContinue
    }
}
Set-Alias ll Get-ChildItem
Set-Alias la 'Get-ChildItem -Force'

# --- Git Aliases ---
Remove-Alias gc, gco, gcb, gl, gp, gst, gb, ga, grs, grss, gcm -Force -ErrorAction SilentlyContinue

function gc  { git commit -ev @args }
function gco { git checkout @args }
function gcb { git checkout -b @args }
function gl  { git pull @args }
function gp  { git push @args }
function gst { git status @args }
function gb  { git branch @args }
function ga  { git add @args }
function grs { git restore @args }
function grss{ git restore --staged @args }

function gcm {
    $branch = @( 'master', 'main', 'develop' ) | Where-Object { git rev-parse --verify $_ 2>$null } | Select-Object -First 1
    if (-not $branch) { Write-Error "No default branch found"; return }
    git checkout $branch @args
}


# --- Environment ---
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"
$env:LESS = "-R"

# --- Functions ---
function which($cmd) {
    Get-Command $cmd | Select-Object -ExpandProperty Source
}

# TODO: Update with private / work
function tabs() {
    wt -w 0 nt --tabColor '#00FF00' --title Wiki --suppressApplicationTitle ` -d 'C:\git\wiki'
    wt -w 0 split-pane -V --tabColor '#00FF00' --title Dotfiles --suppressApplicationTitle ` -d 'C:\git\dotfiles'
    wt -w 0 nt --tabColor '#0000ff' --title Product --suppressApplicationTitle -d 'C:\git\Product'
    wt -w 0 nt --tabColor '#0000ff' --title Drivers --suppressApplicationTitle -d 'C:\git\Product.Drivers'
    wt -w 0 nt --tabColor '#0000ff' --title TreatAPI --suppressApplicationTitle -d 'C:\git\Product.Treat.API'
    wt -w 0 nt --tabColor '#F000F0' --title Product2 --suppressApplicationTitle -d 'C:\git\Product2'
    wt -w 0 nt --tabColor '#F000F0' --title Drivers2 --suppressApplicationTitle -d 'C:\git\Product.Drivers2'
    wt -w 0 nt --tabColor '#F000F0' --title TreatAPI2 --suppressApplicationTitle -d 'C:\git\Product.Treat.API2'
    wt -w 0 nt --tabColor '#ff0000' --title OtherProduct --suppressApplicationTitle -d 'C:\git\OtherProduct'
}

# TODO: Better solution than folder specific?
function Build {
    if ($PWD.Path -match "C:\\git\\Product\.Drivers2?") {
        Get-ChildItem -Path "C:\git\Product.Drivers" -Filter *DomainModel.csproj -Recurse -Depth 3 -File | ForEach-Object { dotnet build $_.FullName }
        dotnet build "src\Product.Drivers.sln"
    }

    if ($PWD.Path -match "C:\\git\\Product\.Treat\.Api2?") {
        dotnet build "src\Product.Treat.Api.sln"
    }

    if ($PWD.Path -match "C:\\git\\Product2?$") {
        $scriptPath = Join-Path $PWD "Build.ps1"

        if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            $command = "-NoProfile -ExecutionPolicy Bypass -Command `"& { `"$scriptPath`"; (New-Object -ComObject SAPI.SpVoice).Speak('Build done'); Write-Host 'Press any key to exit...'; $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') }`""
            Start-Process powershell $command -Verb RunAs
            return
        }
    }

    (New-Object -ComObject SAPI.SpVoice).Speak("Build done")
}

function install_module_if_missing($moduleName) {
    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        Install-Module $moduleName -Scope CurrentUser -Force
        Write-Host "$moduleName installed. Restart PowerShell to load the module."
    }
    Import-Module $moduleName
}

# ---  Modules ---
install_module_if_missing -moduleName PSReadLine
install_module_if_missing -moduleName PSFzf
install_module_if_missing -moduleName Terminal-Icons

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Key Ctrl+p -ScriptBlock {
    $locations = @("D:\Documents\Projects", "D:\Documents\Software", "C:\git")
    $directories = $locations | ForEach-Object { Get-ChildItem -Path $_ -Directory -Depth 2 }
    $directories | Select-Object -ExpandProperty FullName | Invoke-Fzf | Set-Location
}

Set-PSReadLineKeyHandler -Key Ctrl+s -ScriptBlock {
    $files = Get-ChildItem -Recurse -Path "*.sln" -Depth 2
    $files | Select-Object -ExpandProperty FullName | Invoke-Fzf | Invoke-Item
}

Set-PSReadLineKeyHandler -Key Ctrl+g -ScriptBlock {
    lazygit
}

function Show-StartMessage {
    Clear-Host

    $user = $env:USERNAME
    $hostname = [System.Net.Dns]::GetHostName()

    $title = "$([char]27)[38;5;14mWelcome, $user@$hostname$([char]27)[0m"
    Write-Host "$title`n"

    Write-Host "$([char]27)[38;5;10mPSReadLine / FZF Keybindings:$([char]27)[0m"
    Write-Host "  Ctrl+f  → FZF file search"
    Write-Host "  Ctrl+s  → FZF solution (.sln) search"
    Write-Host "  Ctrl+p  → FZF directory search"
    Write-Host "  Ctrl+g  → lazygit"
    Write-Host ""
}

Show-StartMessage
