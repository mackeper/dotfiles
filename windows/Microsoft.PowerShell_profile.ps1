# --- PowerShell Profile ---
# Author: Marcus

# --- Perferred tools ---
# - eza: choco install eza -y
# - fzf: choco install fzf -y
# - fd: choco install fd -y
# - lazygit: choco install lazygit -y
# - delta: choco install delta -y
# - neovim: https://github.com/neovim/neovim/releases

# VC:
# 0.1: Initial version
# 0.2: Admin terminal function, start driver function
# 0.3: Git worktrees

function Show-StartMessage {
    Clear-Host

    $user = $env:USERNAME
    $hostname = [System.Net.Dns]::GetHostName()
    $profileVersion = "0.3 worktrees"
    $col1 = 46

    $title = "$([char]27)[38;5;14mWelcome, $user@$hostname (v$profileVersion)$([char]27)[0m"
    Write-Host "$title`n"

    $col1Values = @(
        @("$([char]27)[38;5;10mKey bindings:$([char]27)[0m", ""),
        @("Ctrl+F", "FZF file search"),
        @("Ctrl+S", "FZF solution (.sln) search"),
        @("Ctrl+J", "FZF project search"),
        @("Alt+C", "FZF directory search"),
        @("Ctrl+G", "lazygit"),
        @("", ""),
        @("$([char]27)[38;5;10mUseful functions:$([char]27)[0m", ""),
        @("admin", "Open an elevated terminal"),
        @("build", "Build current project"),
        @("driver", "Start/stop a treatment driver"),
        @("tabs", "Open preset tabs"),
        @("guid", "Generate a new GUID"),
        @("test", "FZF C# test runner"),
        @("", ""),
        @("$([char]27)[38;5;10mUseful functions:$([char]27)[0m", ""),
        @("fkill", "Fzf kill process"),
        @("", ""),
        @("", ""),
        @("", ""),
        @("", "")
    )
    $col2Values = @(
        @("$([char]27)[38;5;10mGit aliases:$([char]27)[0m", ""),
        @("gst", "git status"),
        @("ga", "git add"),
        @("gl", "git pull"),
        @("gp", "git push"),
        @("gc", "git commit"),
        @("gd", "git diff"),
        @("gco", "git checkout"),
        @("gcm", "default branch"),
        @("gb", "git branch"),
        @("# Worktrees", ""),
        @("gwtl", "worktree list"),
        @("gwta", "worktree add"),
        @("gwtr", "worktree remove"),
        @("# Analyze", ""),
        @("gwho", "commits by author"),
        @("gchurn", "files that change the most"),
        @("gbugs", "files with most problems"),
        @("gmonthly", "commits by month"),
        @("gdmg", "revert frequency"),
        @("", ""),
        @("", ""),
        @("", ""),
        @("", ""),
        @("", "")
    )

    for ($i = 0; $i -lt $col1Values.Length; $i++) {
        $isCol1TitleRow = $col1Values[$i][0] -ne "" -and $col1Values[$i][1] -eq ""
        $col1Width = $isCol1TitleRow ? $col1 + 14 : $col1

        $col1Value = $col1Values[$i][1] -eq "" `
            ? ("{0,-8}" -f $col1Values[$i][0]) `
            : ("{0,-8} → {1}" -f $col1Values[$i][0], $col1Values[$i][1])

        $col2Value = $col2Values[$i][1] -eq "" `
            ? ("{0,-8}" -f $col2Values[$i][0]) `
            : ("{0,-8} → {1}" -f $col2Values[$i][0], $col2Values[$i][1])

        Write-Host ("{0,-$col1Width}{1}" -f $col1Value, $col2Value)
    }
}

# ========================================
#              Shell options
# ========================================
$OnViModeChange = [scriptblock]{
    Write-Host -NoNewLine $(if ($args[0] -eq 'Command') {"`e[1 q"} else {"`e[5 q"})
}
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None


# ========================================
#              Prompt
# ========================================
function prompt {
    $path = (Get-Location).Path.Replace($HOME, '~')
    $branch = ''
    $gitInfo = ''
    if (git rev-parse --is-inside-work-tree 2>$null) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        git diff --quiet 2>$null; $hasDiff = $LASTEXITCODE -ne 0
        git diff --cached --quiet 2>$null; $hasStaged = $LASTEXITCODE -ne 0
        if ($hasDiff -or $hasStaged) { $gitInfo = " $([char]27)[38;5;9m~$([char]27)[0m" }
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
function ll {
    if (Get-Command eza -ErrorAction SilentlyContinue) { eza -la --icons --git --group-directories-first @args }
    else { Get-ChildItem -Force @args }
}
function lt {
    if (Get-Command eza -ErrorAction SilentlyContinue) { eza --tree --level=2 --icons @args }
    else { Get-ChildItem -Recurse -Depth 2 @args }
}
function la {
    if (Get-Command eza -ErrorAction SilentlyContinue) { eza -la --icons @args }
    else { Get-ChildItem -Force @args }
}
Set-Alias hide 'Set-PSReadLineOption -HistorySaveStyle SaveNothing'

# ========================================
#              Git Aliases
# ========================================

# --- Commands to analyze git history, ga "git analyze" ---
# https://piechowski.io/post/git-commands-before-reading-code/
# Commit count:
function gwho { git shortlog -sn --no-merges }
# Files that change the most:
function gchurn { git log --format=format: --name-only --since="1 year ago" | ? {$_} | group | sort Count -desc | select -f 20 |  % { "{0,5} {1}" -f $_.Count, $_.Name } }
# Files with most problems:
function gbugs { git log -i -E --grep="(fix|bug|broken|issue|resolve|repair|fail|crash)" --name-only --format='' | group | sort Count -desc | select -f 20 | % { "{0,5} {1}" -f $_.Count, $_.Name } }
# Commits by month
function gmonthly { git log --format='%ad' --date=format:'%Y-%m' | group | sort Name -desc }
# Revert frequency:
function gdmg { git log --oneline --since="1 year ago" -i -E --grep "(revert|hotfix|emergency|rollback)" }

Remove-Alias gc, gco, gcb, gd, gdca, gl, gp, gpn, gst, gb, ga, grs, grss, gcm -Force -ErrorAction SilentlyContinue

function gc  { git commit -ev @args }
function gco { git checkout @args }
function gcb { git checkout -b @args }
function gd { git diff @($args.Count ? $args : ".") }
function gdca { git diff --cached @($args.Count ? $args : ".") }
function gl  { git pull @args }
function gp  { git push @args }
function gpn { & git push --set-upstream origin (git branch --show-current) }
function gst { git status @args }
function gb  { git branch @args }
function ga  { git add @args }
function grs { git restore @args }
function grss{ git restore --staged @args }
function glog { git log `
    --color `
    --graph `
    --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' `
    --abbrev-commit `
    -- @args
}
function gcm {
    $branch = @( 'master', 'main', 'develop' )
        | Where-Object { git rev-parse --verify $_ 2>$null }
        | Select-Object -First 1
    if (-not $branch) { Write-Error "No default branch found"; return }
    git checkout $branch @args
}


function gwt { git worktree @args }
function gwtl { git worktree list @args }
function gwta { git worktree add @args }
function gwtr { git worktree remove @args }

# ========================================
#               Curl tools
# ========================================
function wttr { (Invoke-WebRequest "wttr.in/$(if($args){$args}else{'stockholm'})").Content }
function cht { (Invoke-WebRequest "cht.sh/$args").Content }

# ========================================
#              Environment
# ========================================
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"
$env:LESS = "-R"

# ========================================
#               Functions
# ========================================
function which($cmd) { Get-Command $cmd | Select-Object -ExpandProperty Source }

# TODO: Update with private / work
function tabs() {
    wt -w 0 nt --tabColor '#00FF00' --title Dotfiles --suppressApplicationTitle ` -d 'C:\git\dotfiles'
    wt -w 0 split-pane -V --tabColor '#00FF00' --title Copilot --suppressApplicationTitle ` -d "$env:APPDATA\Code\User"
    wt -w 0 split-pane -H --tabColor '#00FF00' --title Wiki --suppressApplicationTitle ` -d 'C:\git\wiki'
    wt -w 0 nt --tabColor '#F000F0' --title RayCare.WT --suppressApplicationTitle -d 'C:\git\RayCare.WT'
    wt -w 0 nt --tabColor '#F000F0' --title TreatmentDrivers.WT --suppressApplicationTitle -d 'C:\git\RayCare.TreatmentDrivers.WT'
    wt -w 0 nt --tabColor '#F000F0' --title TreatAPI.WT --suppressApplicationTitle -d 'C:\git\RayCare.Treat.API.WT'
    wt -w 0 nt --tabColor '#0000ff' --title RayCare --suppressApplicationTitle -d 'C:\git\RayCare'
    wt -w 0 split-pane -V --tabColor '#0000ff' --title RayCare --suppressApplicationTitle -d 'C:\git\RayCare' powershell -NoExit -File .\MonitorMicroservices.ps1
    wt -w 0 nt --tabColor '#0000ff' --title TreatmentDrivers --suppressApplicationTitle -d 'C:\git\RayCare.TreatmentDrivers'
    wt -w 0 nt --tabColor '#0000ff' --title TreatAPI --suppressApplicationTitle -d 'C:\git\RayCare.Treat.API'
    wt -w 0 nt --tabColor '#ff0000' --title RayStation --suppressApplicationTitle -d 'C:\git\RayStation'
}


function Invoke-AdminAndStreamOutput {
    param(
        [string]$AdminCommand,
        [string]$TempFile = $(Join-Path "C:/tmp" ("rc_build_" + [guid]::NewGuid().ToString() + ".txt"))
    )

    # Ensure temp directory exists
    if (-not (Test-Path "C:/tmp")) {
        New-Item -ItemType Directory -Path "C:/tmp" | Out-Null
    }

    # Start admin PowerShell to run command and write output to temp file
    $psCommand = "$AdminCommand | Tee-Object -FilePath '$TempFile'"
    $proc = Start-Process powershell.exe -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $psCommand) -Verb RunAs -PassThru

    Write-Host "Streaming output from $TempFile..."

    $lastLength = 0
    while ($proc.HasExited -eq $false) {
        if (Test-Path $TempFile) {
            $content = Get-Content $TempFile -Raw
            if ($content.Length -gt $lastLength) {
                Write-Host $content.Substring($lastLength)
                $lastLength = $content.Length
            }
        }
        Start-Sleep -Seconds 1
        $proc.Refresh()
    }

    # Print any remaining output
    if (Test-Path $TempFile) {
        $content = Get-Content $TempFile -Raw
        if ($content.Length -gt $lastLength) {
            Write-Host $content.Substring($lastLength)
        }
    }

    Remove-Item $TempFile -Force
}

# TODO: Better solution than folder specific?
function Build {
    if ($PWD.Path -match "C:\\git\\RayCare\.TreatmentDrivers2?") {
        Get-ChildItem -Filter *DomainModel.csproj -Recurse -Depth 5 -File | ForEach-Object { dotnet build $_.FullName }
        dotnet build "src\RayCare.TreatmentDrivers.sln"
    }

    if ($PWD.Path -match "C:\\git\\RayCare\.Treat\.Api2?") {
        dotnet build "src\RayCare.Treat.Api.sln"
    }

    if ($PWD.Path -match "C:\\git\\RayCare2?$") {
        $scriptPath = Join-Path $PWD "Build.ps1"

        if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            $command = "-NoProfile -ExecutionPolicy Bypass -Command `"& { `"$scriptPath`"; (New-Object -ComObject SAPI.SpVoice).Speak('Build done'); Write-Host 'Press any key to exit...'; $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') }`""
            Start-Process powershell $command -Verb RunAs
            return
        }
    }

    (New-Object -ComObject SAPI.SpVoice).Speak("Build done")
}
function guid {
    [guid]::NewGuid().ToString() | Tee-Object -Variable g
    Set-Clipboard $g
    Write-Host "(copied)"
}

# ========================================
#              Modules
# ========================================
function install_module_if_missing($moduleName) {
    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        Install-Module $moduleName -Scope CurrentUser -Force
        Write-Host "$moduleName installed. Restart PowerShell to load the module."
    }
    Import-Module $moduleName
}

install_module_if_missing -moduleName PSReadLine
install_module_if_missing -moduleName PSFzf
install_module_if_missing -moduleName Terminal-Icons

$env:FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
$env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
$env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
$env:FZF_ALT_C_COMMAND = 'fd --type d --hidden --follow --exclude .git'
Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+f' `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordSetLocation 'Alt+c'
Set-PsFzfOption -TabExpansion
Set-PsFzfOption -TabCompletionPreviewWindow 'right|down|hidden'

Set-PsFzfOption -EnableAliasFuzzyKillProcess # fkill alias

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Key Ctrl+j -ScriptBlock {
    $locations = @("D:\Documents\Projects", "D:\Documents\Software", "C:\git")
    $directories = $locations | ForEach-Object { if (Test-Path $_) {Get-ChildItem -Path $_ -Directory -Depth 2} }
    $directories | Select-Object -ExpandProperty FullName | Invoke-Fzf | Set-Location
}

Set-PSReadLineKeyHandler -Key Ctrl+s -ScriptBlock {
    $files = Get-ChildItem -Recurse -Path "*.sln" -Depth 2
    $files | Select-Object -ExpandProperty FullName | Invoke-Fzf | Invoke-Item
}

Set-PSReadLineKeyHandler -Key Ctrl+g -ScriptBlock {
    lazygit
}

Remove-PSReadLineKeyHandler -Chord Ctrl+t

# Default TestInfo display: only Fqn
Update-TypeData -TypeName 'TestInfo' -DefaultDisplayPropertySet 'Fqn' -Force
Update-TypeData -TypeName 'TestInfo' -MemberType ScriptMethod -MemberName ToString -Value { $this.Fqn } -Force

function Find-TestProject {
    param([Parameter(ValueFromPipeline)][string]$Filter = '')
    process { fd -i "(Tests?|Specs?)\.csproj$" 2>$null | Where-Object { -not $Filter -or $_ -match [regex]::Escape($Filter) } }
}
Set-Alias test-csproj Find-TestProject

function Find-Test {
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Project,
        [string]$Filter = ''
    )
    process {
        $projectDir = Split-Path $Project -Parent
        $projectName = [IO.Path]::GetFileNameWithoutExtension($Project)
        $pattern = '\[(?:Test|TestMethod|Fact|Theory)[^\]]*\][\s\S]*?\b(?:public|private|internal)\s+(?:static\s+)?(?:async\s+)?(?:Task|void)\s+(\w+)\s*\('
        rg -U --pcre2 --json $pattern $projectDir --glob '*.cs' | ForEach-Object {
            $obj = $_ | ConvertFrom-Json
            if ($obj.type -eq 'match') {
                $matchText = $obj.data.submatches[0].match.text
                if ($matchText -match '\b(?:Task|void)\s+(\w+)\s*\(') {
                    $filePath = $obj.data.path.text
                    $relDir = [IO.Path]::GetRelativePath($projectDir, (Split-Path $filePath -Parent))
                    $ns = if ($relDir -eq '.') { $projectName } else { "$projectName." + ($relDir -replace '[\\/]', '.') }
                    $class = [IO.Path]::GetFileNameWithoutExtension($filePath).Split('.')[0]
                    $fqn = "$ns.$class.$($Matches[1])"
                    if (-not $Filter -or $fqn -match [regex]::Escape($Filter)) { $fqn }
                }
            }
        }
    }
}
Set-Alias test-fd Find-Test

function Invoke-TestCase {
    param(
        [Parameter(Mandatory)][string]$Project,
        [Parameter(Mandatory, ValueFromPipeline)][string]$Fqn,
        [switch]$NoHistory
    )
    process {
        $command = "dotnet test $Project --no-build --filter `"FullyQualifiedName~$Fqn`""
        if (-not $NoHistory) { [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($command) }
        Invoke-Expression $command
    }
}
Set-Alias test-case Invoke-TestCase

function Invoke-Test {
    $project = Find-TestProject | Invoke-Fzf
    $fqn = Find-Test -Project $project | Invoke-Fzf
    Invoke-TestCase -Project $project -Fqn $fqn
}
Set-Alias test Invoke-Test

# ========================================
#              Mimic linux
# ========================================
function touch($file) { if (Test-Path $file) { (Get-Item $file).LastWriteTime = Get-Date } else { New-Item $file -ItemType File } }
function wget {
    param([string]$url, [string]$o)
    $outFile = if ($o) { $o } else { Split-Path $url -Leaf }
    Invoke-WebRequest $url -OutFile $outFile
}
function grep {
    if (Get-Command rg -ErrorAction SilentlyContinue) { $input | rg --color=auto @args }
    else { $input | Select-String @args }
}
function head { param($n=10) $input | Select-Object -First $n }
function tail {
    param([int]$n = 10, [switch]$f)
    if ($f) {
        if ($args.Count -eq 0) { Write-Error "tail -f requires a file path"; return }
        Get-Content $args[0] -Tail $n -Wait
    } else {
        if ($args.Count -gt 0) { Get-Content $args[0] | Select-Object -Last $n }
        else { $input | Select-Object -Last $n }
    }
}
function open { Invoke-Item $args }

function Start-TreatmentDriver {
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Start', 'Stop', IgnoreCase = $true)]
        [string]$Command = 'Start',

        [Parameter(Position = 1)]
        [ValidateSet('CyberKnife', 'Oxray', 'ProBeat', 'ProBeatMarie', 'ProteusOne', 'StandardDriver', 'Tomo', 'TrueBeam', IgnoreCase = $true)]
        [string]$Driver,

        [switch]$Subscriptions
    )

    if (-not $Driver) {
        $drivers = (Get-Command Start-TreatmentDriver).Parameters['Driver'].Attributes.ValidValues -join ', '
        Write-Host "Usage: driver <Start|Stop> <Driver> [-Subscriptions]"
        Write-Host "  Drivers: $drivers"
        return
    }

    $map = @{
        CyberKnife     = 'CyberKnife/RayCare.TreatmentDrivers.TDW1.CyberKnife'
        Oxray          = 'Oxray/RayCare.TreatmentDrivers.TDW1.Oxray'
        ProBeat        = 'ProBeat/RayCare.TreatmentDrivers.TDW2.ProBeat'
        ProBeatMarie   = 'ProBeatMarie/RayCare.TreatmentDrivers.TDW2.Hitachi.ProBeatMarie'
        ProteusOne     = 'ProteusOne/RayCare.TreatmentDrivers.TDW2.ProteusOne'
        StandardDriver = 'StandardDriver/RayCare.TreatmentDrivers.TDW2.StandardDriver'
        Tomo           = 'Tomo/RayCare.TreatmentDrivers.TDW1.Tomo'
        TrueBeam       = 'TrueBeam/RayCare.TreatmentDrivers.RTX.TrueBeam'
    }

    $suffix = if ($Subscriptions) { ".Subscriptions.Host" } else { ".Host" }
    $processName = "$($map[$Driver])$suffix".Split('/')[-1]

    if ($Command -eq 'Stop') {
        $procs = Get-Process -Name $processName -ErrorAction SilentlyContinue
        if ($procs) {
            $procs | Stop-Process -Force
            Write-Host "Stopped $processName"
        } else {
            Write-Host "No running process found for $processName"
        }
        return
    }

    $repoRoot = $PWD.Path
    while ($repoRoot -and -not (Test-Path (Join-Path $repoRoot 'src\drivers'))) {
        $parent = Split-Path $repoRoot -Parent
        if ($parent -eq $repoRoot) { $repoRoot = $null; break }
        $repoRoot = $parent
    }
    if (-not $repoRoot) {
        Write-Error "Could not find repo root. Navigate to a directory within the RayCare.TreatmentDrivers repo."
        return
    }

    $base = "src/drivers/$($map[$Driver])"
    $project = "$base$suffix"

    Push-Location $repoRoot
    try {
        dotnet run --project $project
    } finally {
        Pop-Location
    }
}
Set-Alias driver Start-TreatmentDriver

function Invoke-AdminTerminal {
    param(
        [string]$Command = ""
    )
    $wt = Get-Command wt.exe -ErrorAction SilentlyContinue
    $cwd = $PWD.Path

    if ($wt) {
        $wtArgs = @("-d", $cwd)
        if ($Command) {
            $wtArgs += "--command"
            $wtArgs += $Command
        }
        Start-Process wt.exe -ArgumentList $wtArgs -Verb RunAs
    } else {
        $psCommand = $Command ? "$Command; cd '$cwd'" : "cd '$cwd'"
        Start-Process powershell.exe -ArgumentList @("-NoExit", "-Command", $psCommand) -Verb RunAs
    }
}
Set-Alias admin Invoke-AdminTerminal

Show-StartMessage
