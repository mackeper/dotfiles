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
# 0.4: Service status in prompt, test runner
# 0.5: Speed up startup

function Show-DailyTip {
    $tipsFile = Join-Path $PSScriptRoot 'tips.json'
    if (-not (Test-Path $tipsFile)) { return }
    $data = Get-Content $tipsFile -Raw | ConvertFrom-Json
    if (-not $data) { return }
    $all = foreach ($cat in $data.PSObject.Properties) {
        foreach ($t in $cat.Value) { [PSCustomObject]@{ Category = $cat.Name; Tip = $t } }
    }
    if (-not $all) { return }
    $pick = $all | Get-Random
    Write-Host "`n$([char]27)[38;5;8m[$($pick.Category)]$([char]27)[0m $([char]27)[38;5;14m`u{1F4A1} $($pick.Tip)$([char]27)[0m`n"
}

function Show-StartMessage {
    Clear-Host

    $user = $env:USERNAME
    $hostname = [System.Net.Dns]::GetHostName()
    $profileVersion = "0.5 speed up startup"
    $col1 = 46

    $title = "$([char]27)[38;5;14mWelcome, $user@$hostname (v$profileVersion)$([char]27)[0m"
    Write-Host "$title`n"

    $col1Values = @(
        @("$([char]27)[38;5;10mKey bindings:$([char]27)[0m", ""),
        @("Ctrl+F", "FZF file search"),
        @("Ctrl+S", "FZF solution (.sln) search"),
        @("Ctrl+P", "FZF project search"),
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
        @("$([char]27)[38;5;10mFzf functions:$([char]27)[0m", ""),
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

    Show-DailyTip
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
    $e = [char]27
    $path = $PWD.Path.Replace($HOME, '~')

    # Set the Windows Terminal tab title to the current directory name.
    $Host.UI.RawUI.WindowTitle = Split-Path -Leaf $PWD.Path

    # One git call instead of four: branch + dirty state in a single subprocess.
    #   -uno              skip untracked scan (faster in big repos; matches old diff-based ~)
    #   --no-optional-locks  don't contend for index.lock with a running git command
    # Porcelain v2 emits all '# ...' headers before any file lines, so the first
    # non-header line means "dirty" and we can stop early.
    $display = ''
    $status = git --no-optional-locks status --porcelain=v2 --branch -uno 2>$null
    if ($LASTEXITCODE -eq 0) {
        $branch = ''
        $dirty = $false
        foreach ($line in $status) {
            if ($line[0] -eq '#') {
                if ($line.StartsWith('# branch.head ')) { $branch = $line.Substring(14) }
            } else { $dirty = $true; break }
        }
        if ($branch) {
            $gitInfo = if ($dirty) { " $e[38;5;9m~$e[0m" } else { '' }
            $display = "$e[38;5;15m ($e[38;5;10m$branch$gitInfo$e[38;5;15m)"
        }
    }

    $svcInfo = ''
    if ($PWD.Path -match '^C:\\git\\RayCare(2|\.WT)?$') {
        $count = @(Get-Process -Name 'RayCare*' -ErrorAction SilentlyContinue).Count
        if ($count) { $svcInfo = " $e[38;5;14m[$count svc]$e[0m" }
    }

    "$e[38;5;10mPS$e[0m $e[38;5;15m$path$display$svcInfo$e[0m > "
}

# ========================================
#                Aliases
# ========================================
Remove-Alias ls -Force -ErrorAction SilentlyContinue
function ls([string]$path = ".") {
    if (Get-Command -Name "eza" -ErrorAction SilentlyContinue) {
        eza --group-directories-first --icons $path
    } else {
        # Lazy-load Terminal-Icons: only when eza is absent and ls first runs (idempotent, no startup cost).
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
        Get-ChildItem -Exclude ".*" $path | Format-Wide -AutoSize -ErrorAction SilentlyContinue | ForEach-Object {
            if ($_.GetType().Name -eq "GroupStartData") { $_.groupingEntry = $null }  # drop the "Directory:" header, keep icons
            $_
        }
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

# --- Work shortcuts ---
function rc    { Set-Location 'C:\git\RayCare' }
function rc2   { Set-Location 'C:\git\RayCare2' }
function rcw  { Set-Location 'C:\git\RayCare.WT' }

function tx    { Set-Location 'C:\git\RayCare.TreatmentDrivers' }
function tx2   { Set-Location 'C:\git\RayCare.TreatmentDrivers2' }
function txw  { Set-Location 'C:\git\RayCare.TreatmentDrivers.WT' }

function api   { Set-Location 'C:\git\RayCare.Treat.API' }
function api2  { Set-Location 'C:\git\RayCare.Treat.API2' }
function apiw { Set-Location 'C:\git\RayCare.Treat.API.WT' }

function rs    { Set-Location 'C:\git\RayStation' }
function dd    { Set-Location 'C:\git\DicomDesigner' }
function tt    { Set-Location 'C:\git\RayCare.TreatmentTool' }

function w { Set-Location '~/OneDrive - RaySearch Laboratories AB/Marcus/10_Documents/05_wiki' }

# --- Personal shortcuts ---
function g     { Set-Location 'C:\git' }
function wiki  { Set-Location 'C:\git\wiki' }
function dots  { Set-Location 'C:\git\dotfiles' }
function cc    { Set-Location "$env:APPDATA\Code\User" }
function tmp   { mkdir -f C:\tmp; Set-Location C:\tmp }


# ========================================
#              Git Aliases
# ========================================

function Invoke-GitFzfStatusFiles {
    param(
        [Parameter(Mandatory)][string]$Cmd,
        [ValidateSet('Unstaged', 'Untracked', 'Staged')]
        [string[]]$Filter
    )
    $lines = git status --porcelain
    if ($Filter) {
        $lines = $lines | Where-Object {
            ($Filter -contains 'Unstaged'  -and $_ -match '^ [MDRC]') -or
            ($Filter -contains 'Untracked' -and $_ -match '^\?\?') -or
            ($Filter -contains 'Staged'    -and $_ -match '^[MADRC]')
        }
    }
    $paths = $lines | Invoke-Fzf -m | ForEach-Object { $_.Substring(3) }
    if ($paths) { Invoke-Expression "$Cmd $($paths -join ' ')" }
}

function Invoke-GitOrFzf {
    param(
        [Parameter(Mandatory)][string]$Cmd,
        [ValidateSet('Unstaged', 'Untracked', 'Staged')]
        [string[]]$Filter,
        [Parameter(ValueFromRemainingArguments)][string[]]$Args
    )
    if ($Args.Count) { Invoke-Expression "$Cmd $($Args -join ' ')" }
    else { Invoke-GitFzfStatusFiles -Cmd $Cmd -Filter $Filter }
}

function ga { Invoke-GitOrFzf 'git add' -Filter Unstaged,Untracked @args }
function gd { Invoke-GitOrFzf 'git diff' -Filter Unstaged @args }
function gdc { Invoke-GitOrFzf 'git diff --cached' -Filter Staged @args }
function grs { Invoke-GitOrFzf 'git restore' -Filter Unstaged @args }
function grss { Invoke-GitOrFzf 'git restore --staged' -Filter Staged @args }

function Show-BarChart {
    param(
        [Parameter(ValueFromPipeline)][object[]]$Data,
        [int]$MaxWidth = 40
    )
    begin { $items = @() }
    process { $items += $Data }
    end {
        $max = ($items | Measure-Object Count -Max).Maximum
        if (!$max) { return }
        $lw = ($items | % { "$($_.Name)".Length } | Measure-Object -Max).Maximum
        foreach ($i in $items) {
            $bar = [int]($i.Count / $max * $MaxWidth)
            "{0,-$lw} │{1} {2}" -f $i.Name, ('=' * $bar), $i.Count
        }
    }
}

# --- Commands to analyze git history ---
# https://piechowski.io/post/git-commands-before-reading-code/
function Invoke-GitAnalyze {
    param([string]$Command, [string]$Author)
    $commands = [ordered]@{
        'who      - commits by author'         = { git shortlog -sn --no-merges }
        'churn    - files that change most'    = { git log --format=format: --name-only --since="1 year ago" | ? {$_} | group | sort Count -desc | select -f 20 | % { "{0,5} {1}" -f $_.Count, $_.Name } }
        'bugs     - files with most problems'  = { git log -i -E --grep="(fix|bug|broken|issue|resolve|repair|fail|crash)" --name-only --format='' | group | sort Count -desc | select -f 20 | % { "{0,5} {1}" -f $_.Count, $_.Name } }
        'by-month - commits by month'          = { git log --format='%ad' --date=format:'%Y-%m' | group | sort Name -desc | Show-BarChart }
        'dmg      - revert frequency'          = { git log --oneline --since="1 year ago" -i -E --grep "(revert|hotfix|emergency|rollback)" }
        'by-hour  - commits by hour of day'    = { git log --format='%ad' --date=format:'%H' | group | sort Name | Show-BarChart }
        'by-day   - commits by weekday'        = { git log --format='%ad' --date=format:'%A' | group | sort Count -desc | Show-BarChart }
        'active   - total unique commit days'  = { $d = (git log --format='%ad' --date=short | sort -u | Measure-Object).Count; Write-Host "$d active days" }
        'stale    - branches without recent commits' = { git for-each-ref --sort=committerdate --format='%(committerdate:short) %(refname:short)' refs/heads/ | select -f 15 }
        'shared   - files with most authors'   = { git log --format='%aN' --name-only --since="1 year ago" | ? {$_} | % -Begin { $a=''; $h=@{} } -Process { if ($_ -notmatch '[\\/.]') {$a=$_} elseif($a) {if(!$h[$_]){$h[$_]=[System.Collections.Generic.HashSet[string]]::new([string[]]@())}; $h[$_].Add($a)>$null} } -End { $h.GetEnumerator() | sort {$_.Value.Count} -desc | select -f 20 | % { "{0,5} {1}" -f $_.Value.Count, $_.Key } } }
        'author   - analyze a specific author' = {
            $a = if ($Author) { $Author } else { git shortlog -sn --no-merges | % { ($_ -replace '^\s*\d+\s+','').Trim() } | Invoke-Fzf }
            if (!$a) { return }
            Write-Host "`n$([char]27)[38;5;14m=== $a ===$([char]27)[0m"
            $total = (git log --author="$a" --oneline | Measure-Object).Count
            $first = git log --author="$a" --format='%ad' --date=short --reverse | select -f 1
            $last = git log --author="$a" --format='%ad' --date=short | select -f 1
            $days = (git log --author="$a" --format='%ad' --date=short | sort -u | Measure-Object).Count
            Write-Host "  Commits: $total  Active days: $days  Range: $first → $last`n"
            Write-Host "$([char]27)[38;5;10mBy month:$([char]27)[0m"
            git log --author="$a" --format='%ad' --date=format:'%Y-%m' | group | sort Name -desc | select -f 12 | Show-BarChart
            Write-Host "`n$([char]27)[38;5;10mBy weekday:$([char]27)[0m"
            git log --author="$a" --format='%ad' --date=format:'%A' | group | sort Count -desc | Show-BarChart
            Write-Host "`n$([char]27)[38;5;10mBy hour:$([char]27)[0m"
            git log --author="$a" --format='%ad' --date=format:'%H' | group | sort Name | Show-BarChart
            Write-Host "`n$([char]27)[38;5;10mTop files:$([char]27)[0m"
            git log --author="$a" --format=format: --name-only --since="1 year ago" | ? {$_} | group | sort Count -desc | select -f 15 | % { "  {0,5} {1}" -f $_.Count, $_.Name }
        }
    }
    $pick = if ($Command) { $commands.Keys | ? { $_ -match "^$Command" } | select -f 1 } else { $commands.Keys | Invoke-Fzf }
    if ($pick) { & $commands[$pick] }
}
Set-Alias ganalyze Invoke-GitAnalyze

Remove-Alias gc, gco, gcb, gd, gdca, gl, gp, gpn, gst, gb, ga, grs, grss, gcm -Force -ErrorAction SilentlyContinue

function gc  { git commit -ev @args }
function gco { git checkout @args }
function gcb { git checkout -b @args }
function gdca { git diff --cached @($args.Count ? $args : ".") }
function gl  { git pull @args }
function gg  { git grep @args }
function gp  { git push @args }
function gpn { & git push --set-upstream origin (git branch --show-current) }
function gst { git status @args }
function gb  { git branch @args }
function groot { Set-Location (git rev-parse --show-toplevel) }
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
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:LC_ALL = 'C.UTF-8'

# ========================================
#               Functions
# ========================================
function which($cmd) { $c = Get-Command $cmd; if ($c.Source) { $c.Source } else { $c.Definition } }

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


function Start-PodmanContainers {
    if (-not (Get-Command podman -ErrorAction SilentlyContinue)) {
        Write-Warning "podman not found; skipping container startup"
        return
    }
    # Ensure the podman machine is running (idempotent; harmless if already started).
    if (-not (podman machine inspect --format '{{.State}}' 2>$null | Select-String -SimpleMatch 'running' -Quiet)) {
        Write-Host "Starting podman machine..."
        podman machine start
    }
    $stopped = podman ps -aq --filter status=created --filter status=exited --filter status=paused
    if ($stopped) {
        Write-Host "Starting podman containers..."
        $stopped | ForEach-Object { podman start $_ }
    }
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
        Start-PodmanContainers

        $scriptPath = Join-Path $PWD "Build.ps1"

        # Cake's tools are missing only after e.g. `git clean`. The official bootstrap
        # (bakeCake.ps1) needs admin solely to write the machine-level PATH, which the build
        # never uses (RunCakeTargets.ps1 invokes Cake.exe by full path). So restore the tools
        # unelevated by running preBakeCake.ps1 directly with the correct ToolPath; the whole
        # build then runs without admin.
        $cakeExe = Join-Path $PWD "cake\tools\cake\Cake.exe"
        if (-not (Test-Path $cakeExe)) {
            Write-Host "Cake tools missing (post-clean build): restoring Cake (no admin needed)..."
            $toolPath = Join-Path $PWD "cake\tools"
            & (Join-Path $PWD "cake\tfs\preBakeCake.ps1") -ToolPath $toolPath
            if (-not (Test-Path $cakeExe)) {
                Write-Error "Cake bootstrap failed (Cake.exe still missing); aborting build."
                return
            }
        }

        & $scriptPath
    }

    (New-Object -ComObject SAPI.SpVoice).Speak("Build done")
}

function reconfig {
    param([switch]$Release)

    $root = git rev-parse --show-toplevel 2>$null
    if (-not $root) { Write-Error "Not inside a git repo."; return }
    $root = $root -replace '/', '\'

    $configuration = if ($Release) { 'Release' } else { 'Debug' }
    $script = Join-Path $root 'Scripts\Build\RunConfigurationAction.ps1'
    Start-Process powershell -Verb RunAs -ArgumentList '-NoExit','-NoProfile','-Command',"Set-Location '$root'; & '$script' -Configuration $configuration"
}
function guid {
    [guid]::NewGuid().ToString() | Tee-Object -Variable g
    Set-Clipboard $g
    Write-Host "(copied)"
}

# ========================================
#              Modules
# ========================================
# PSReadLine is auto-loaded by PowerShell before this profile runs — no import needed.
# Terminal-Icons removed: ls/ll/lt/la already render icons via eza.
# PSFzf is lazy-loaded on first use (see Initialize-PSFzf below) to keep startup fast.
# One-time install (run MANUALLY, not on startup):
#   if (-not (Get-Module -ListAvailable PSFzf)) { Install-Module PSFzf -Scope CurrentUser -Force }

$env:FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
$env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
$env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
$env:FZF_ALT_C_COMMAND = 'fd --type d --hidden --follow --exclude .git'

# --- Lazy-load PSFzf (faster startup; loads on first fzf use) ---
function Initialize-PSFzf {
    if (Get-Module PSFzf) { return }
    Import-Module PSFzf -Global
    Set-PsFzfOption `
        -PSReadlineChordProvider 'Ctrl+t' `
        -PSReadlineChordReverseHistory 'Ctrl+r' `
        -PSReadlineChordSetLocation 'Alt+c'
    Set-PsFzfOption -TabExpansion
    Set-PsFzfOption -TabCompletionPreviewWindow 'right|down|hidden'
    Set-PsFzfOption -EnableAliasFuzzyKillProcess # fkill alias
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}

# Stub chords: first press loads PSFzf, then runs the real handler (module-scoped, not exported).
Set-PSReadLineKeyHandler -Key Ctrl+t -ScriptBlock { Initialize-PSFzf; & (Get-Module PSFzf) { Invoke-FzfPsReadlineHandlerProvider } }
Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock { Initialize-PSFzf; & (Get-Module PSFzf) { Invoke-FzfPsReadlineHandlerHistory } }
Set-PSReadLineKeyHandler -Key Alt+c  -ScriptBlock { Initialize-PSFzf; & (Get-Module PSFzf) { Invoke-FzfPsReadlineHandlerSetLocation } }
Set-PSReadLineKeyHandler -Key Tab    -ScriptBlock { Initialize-PSFzf; Invoke-FzfTabCompletion }

# Stub commands: first call loads PSFzf, then forwards via module-qualified name (always resolves once loaded).
function Invoke-Fzf { Initialize-PSFzf; PSFzf\Invoke-Fzf @args }
function fkill { Initialize-PSFzf; PSFzf\Invoke-FuzzyKillProcess @args }

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Key Ctrl+p -ScriptBlock {
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
    $fqns = Find-Test -Project $project | Invoke-Fzf -Multi
    if (-not $fqns) { return }
    $filter = ($fqns | ForEach-Object { "FullyQualifiedName~$_" }) -join ' | '
    $command = "dotnet test $project --no-build --filter `"$filter`""
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($command)

    $logFile = Join-Path ([IO.Path]::GetTempPath()) "test-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
    $passed = 0; $failed = 0; $skipped = 0; $failures = @()
    $count = ($fqns | Measure-Object).Count
    Write-Host "  Running $count test(s)..."

    & dotnet test $project --no-build -v normal --filter "`"$filter`"" 2>&1 | ForEach-Object {
        $line = $_.ToString()
        Add-Content $logFile $line
        if ($line -match '^\s+Passed\s+(\S+)')  { $passed++;  Write-Host "  $([char]0x2713) $($Matches[1])" -ForegroundColor Green }
        elseif ($line -match '^\s+Failed\s+(\S+)')  { $failed++; $failures += $line.Trim(); Write-Host "  $([char]0x2717) $($Matches[1])" -ForegroundColor Red }
        elseif ($line -match '^\s+Skipped\s+(\S+)') { $skipped++; Write-Host "  ~ $($Matches[1])" -ForegroundColor Yellow }
    }

    Write-Host ""
    Write-Host "  P:$passed F:$failed S:$skipped" -ForegroundColor $(if ($failed) { 'Red' } else { 'Green' })
    Write-Host "Log: $logFile"
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
