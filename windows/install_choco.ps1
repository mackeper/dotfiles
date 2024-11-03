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

$softwareList = @(
    "microsoft-windows-terminal"
    "git.install"
    "python3"
    "mingw"
    "powertoys"
    "keepass.install"
    "fzf"
    "gsudo"
    "win32yank"
    "bat"
    "ripgrep"
    "bottom"
    "oh-my-posh"
    "autohotkey"
    I)

function Install-Chocolatey()
{
    Write-Title "Installing Chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function Install-Packages($software)
{
    Write-Title "Installing chocolatey packages"
    foreach ($software in $softwareList)
    {
        if (choco list --lo -r -e $software)
        {
            Write-Host "'$software' is already installed"
        } else
        {
            choco install $software -y
            Write-Host "'$software' is now installed"
        }
    }
}

function Main()
{
    Write-Title "Installing Chocolatey and packages"

    if (-not (Get-Command choco -ErrorAction SilentlyContinue))
    {
        Install-Chocolatey
    }

    Install-Packages
}

Main
