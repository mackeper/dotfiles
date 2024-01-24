Import-Module posh-git
Import-Module Terminal-Icons
(@(& 'C:/Users/macke/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe' init pwsh --config='C:\Users\macke\AppData\Local\Programs\oh-my-posh\themes\jandedobbeleer.omp.json' --print) -join "`n") | Invoke-Expression

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
Remove-Alias ls -Force -ErrorAction SilentlyContinue
function ls
{ Get-ChildItem -Exclude .* | Format-Wide -AutoSize -ErrorAction SilentlyContinue
}
function ll
{ Get-ChildItem
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


Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -PredictionViewStyle ListView
# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# --- Fzf
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

# Remove-Alias cd -Force -ErrorAction SilentlyContinue

# linux like
function which ($command)
{ 
    Get-Command -Name $command -ErrorAction SilentlyContinue | 
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue 
} 

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

Remove-Alias gc -Force -ErrorAction SilentlyContinue
Remove-Alias gcb -Force -ErrorAction SilentlyContinue
Remove-Alias gcm -Force -ErrorAction SilentlyContinue
Remove-Alias gcs -Force -ErrorAction SilentlyContinue
Remove-Alias gl -Force -ErrorAction SilentlyContinue
Remove-Alias gm -Force -ErrorAction SilentlyContinue
Remove-Alias gp -Force -ErrorAction SilentlyContinue
Remove-Alias gpv -Force -ErrorAction SilentlyContinue

function g
{ & git $args 
}
function ga
{ & git add $args 
}
function gaa
{ & git add -a $args 
}
function gau
{ & git add -u $args 
}
function gb
{ & git branch $args 
}
function gbr
{ & git branch --remote $args 
}
function gbl
{ & git blame -b -w $args 
}
function gc
{ & git commit -ev $args 
}
function gc!
{ & git commit -ev --amend $args 
}
function gclean
{ & git clean -fX 
}
function gcleanvs
{ & git clean -fX -e !.vs 
}
function gco
{ & git checkout $args 
}
function gcob
{ & git checkout -b $args 
}
function gcm
{ git checkout $((git rev-parse --verify master 2>$null) ? 'master' : 'main' ) $args 
}
function gcl
{ & git checkout - $args 
}
function gd
{ & git diff $args 
}
function gdca
{ & git diff --cached $args 
}
function gdcw
{ & git diff --cached --word-diff $args 
}
function gdct
{ & git describe --tags $(git rev-list --tags --max-count=1) $args 
}
function gds
{ & git diff --staged $args 
}
function gdt
{ & git diff-tree --no-commit-id --name-only -r $args 
}
function gdw
{ & git diff --word-diff $args 
}
function gdss
{ & git diff --shortstat $args 
}
function gf
{ & git fetch $args 
}
function gfa
{ & git fetch --all --prune $args 
}
function gfo
{ & git fetch origin $args 
}
function gg
{ & git grep -n $args 
}
function ggwt([Parameter(Mandatory=$true)][string]$Pattern, [string]$filePattern="*.cs")
{ & git grep -n $Pattern -- $filePattern ":!*Fixture*" ":!*Test*" 
}
function gl
{ & git pull $args 
}
function glg
{ & git log --stat $args 
}
function glgp
{ & git log --stat -p $args 
}
function glgg
{ & git log --graph $args 
}
function glgga
{ & git log --graph --decorate --all $args 
}
function glgm
{ & git log --graph --max-count=10 $args 
}
function glo
{ & git log --oneline --decorate $args 
}
function glol
{ & git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' $args 
}
function glols
{ & git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat $args 
}
function glod
{ & git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' $args 
}
function glods
{ & git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short $args 
}
function glola
{ & git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all $args 
}
function glog
{ & git log --oneline --decorate --graph $args 
}
function gloga
{ & git log --oneline --decorate --graph --all $args 
}
function gm
{ & git merge $args 
}
function gmt
{ & git mergetool --no-prompt $args 
}
function gmtvim
{ & git mergetool --no-prompt --tool=vimdiff $args 
}
function gp
{ & git push $args 
}
function gpn
{ & git push --set-upstream origin (git branch --show-current) 
}
function greh
{ & git reset $args 
}
function grm
{ & git rm $args 
}
function grmc
{ & git rm --cached $args 
}
function grs
{ & git restore $args 
}
function grss
{ & git restore --staged $args 
}
function gss
{ & git status -s $args 
}
function gst
{ & git status $args 
}
function gstaa
{ & git stash apply $args 
}
function gstc
{ & git stash clear $args 
}
function gstd
{ & git stash drop $args 
}
function gstl
{ & git stash list $args 
}
function gstp
{ & git stash pop $args 
}
function gsts
{ & git stash show --text $args 
}
function gstu
{ & git stash --include-untracked $args 
}
function gstall
{ & git stash --all $args 
}







































