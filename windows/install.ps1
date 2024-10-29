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

function New-Profile()
{
    Write-Title "Creating profile"
    $profilePath = $PROFILE
    if (!(Test-Path $profilePath))
    {
        New-Item -ItemType File -Path $profilePath
        Write-Success "Created $profilePath"
    } else
    {
        Write-Info "$profilePath already exists"
    }
}

function Copy-Configs()
{
    Write-Title "Copying configs"
    $filesToCopy = @(
        # Powershell
        [Tuple]::Create("https://raw.githubusercontent.com/mackeper/dotfiles/master/windows/Powershell/Microsoft.PowerShell_profile.ps1", (Get-Item $PROFILE).Directory)
        [Tuple]::Create("https://raw.githubusercontent.com/mackeper/dotfiles/master/windows/Powershell/git_aliases.ps1", (Get-Item $PROFILE).Directory)
        [Tuple]::Create("https://raw.githubusercontent.com/mackeper/dotfiles/master/windows/Powershell/mimic_linux.ps1", (Get-Item $PROFILE).Directory)
        [Tuple]::Create("https://raw.githubusercontent.com/mackeper/dotfiles/master/windows/Powershell/modules.ps1", (Get-Item $PROFILE).Directory)

        # Git
        [Tuple]::Create("https://raw.githubusercontent.com/mackeper/dotfiles/master/.gitconfig", $env:USERPROFILE)

        # Development
        [Tuple]::Create("https://raw.githubusercontent.com/mackeper/dotfiles/master/JetBrains/.ideavimrc", $env:USERPROFILE)
    )

    foreach ($file in $filesToCopy)
    {
        $url = $file.Item1
        $filename = Split-Path $url -Leaf
        $destination = "$($file.Item2)\$filename"

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
            Write-Error $_.Exception.Message
            continue
        }

        Write-Success "Copied $filename to $destination"
    }
}

function New-Bin-Path()
{
    Write-Title "Creating bin path"
    $binPath = "$((Get-Item $PROFILE).Directory)\bin_path.ps1"
    if (!(Test-Path $binPath))
    {
        New-Item -ItemType File -Path $binPath
        Write-Success "Created $binPath"
    } else
    {
        Write-Info "$binPath already exists"
    }
}

function Install-Nvim()
{
    Write-Title "Installing Neovim"
    $nvimPath = "$env:LOCALAPPDATA\nvim"
    if (!(Test-Path $nvimPath))
    {
        mkdir "$nvimPath_bak"
        Move-Item -r "$nvimPath" "$nvimPath_bak"
    }
}

function Get-Dotfiles()
{
    Write-Title "Getting dotfiles"
    $dotfilesPath = "$env:USERPROFILE\Documents\git\dotfiles"
    if (!(Test-Path $dotfilesPath))
    {
        git clone 
    }
}

function main()
{
    Write-Title "Starting installation"
    New-Profile
    Copy-Configs
    New-Bin-Path
    Write-Title "Installation complete"
}

main
