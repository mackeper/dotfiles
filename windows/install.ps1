function Write-Title($message)
{ Write-Host "`n$($PSStyle.Foreground.Black)$($PSStyle.Background.Blue)$message$($PSStyle.Reset)"
}
function Write-Error($message)
{ Write-Host "[ error ] $message" -ForegroundColor Red
}
function Write-Warning($message)
{ Write-Host "[ warning ] $message" -ForegroundColor Yellow
}
function Write-Info($message)
{ Write-Host "[ info ] $message" -ForegroundColor Cyan
}
function Write-Debug($message)
{ Write-Host "[ debug ] $message" -ForegroundColor Green
}
function Write-Success($message)
{ Write-Host "[ success ] $message" -ForegroundColor Green
}

function Copy-Configs()
{
    Write-Title "Copying configs"
    filesToCopy = @(
        # Powershell 
        [Tuple]::Create("https://github.com/mackeper/dotfiles/blob/master/windows/Powershell/Microsoft.PowerShell_profile.ps1", (Get-Item $PROFILE).Directory),
        [Tuple]::Create("https://github.com/mackeper/dotfiles/blob/master/windows/Powershell/mimic_linux.ps1", (Get-Item $PROFILE).Directory),
        [Tuple]::Create("https://github.com/mackeper/dotfiles/blob/master/windows/Powershell/git_aliases.ps1", (Get-Item $PROFILE).Directory),

        # Git
        [Tuple]::Create("https://github.com/mackeper/dotfiles/blob/master/windows/Powershell/Microsoft.PowerShell_profile.ps1", $env:USERPROFILE)
    )

    foreach ($file in $filesToCopy)
    {
        $url = $file.Item1
        $filename = Split-Path $url -Leaf
        $destination = "$file.Item2\$filename"

        if (Test-Path $destination)
        {
            Write-Warning "$destination already exists. Creating backup $destination.bak."
            Copy-Item $destination "$destination.bak" 
        }

        try
        {
            Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction Stop
        } catch
        {
            Write-Error "Failed to download $url"
            continue
        }

        Write-Success "Copied $filename to $destination"
    }

    # # Powershell
    # Copy-Item $SCRIPT_DIR\Powershell\Microsoft.PowerShell_profile.ps1 $PROFILE
    # Write-Info "Copied Microsoft.PowerShell_profile.ps1 to $PROFILE"
    # Copy-Item $SCRIPT_DIR\Powershell\mimic_linux.ps1 (Get-Item $PROFILE).Directory
    # Write-Info "Copied mimic_linux.ps1 to $PROFILE directory"
    # Copy-Item $SCRIPT_DIR\Powershell\git_aliases.ps1 (Get-Item $PROFILE).Directory 
    # Write-Info "Copied git_aliases.ps1 to $PROFILE directory"
    #
    # # Git
    # Copy-Item $SCRIPT_DIR\..\.gitconfig (Join-Path $env:USERPROFILE ".gitconfig")
    # Write-Info "Copied .gitconfig to $env:USERPROFILE"
}

function main()
{
    Write-Title "Starting installation"
    Copy-Configs
    Write-Title "Installation complete"
}

main
