
# ----------------------------------------
# --- Oh my posh
# ----------------------------------------
(@(& 'C:/Users/macke/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe' init pwsh --config='C:\Users\macke\AppData\Local\Programs\oh-my-posh\themes\jandedobbeleer.omp.json' --print) -join "`n") | Invoke-Expression

# ----------------------------------------
# --- Source files
# ----------------------------------------
$sourceFiles = @(
    "$PSSCRIPTROOT\bin_path.ps1",
    "$PSSCRIPTROOT\modules.ps1",
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
