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

$binPath = "C:\bin"
$pathFile = "$((Get-Item $PROFILE).Directory)\bin_path.ps1"

function Install-Software($name, $url, $binaryPath)
{
    $filename = Split-Path $url -Leaf

    if (Test-Path "$binPath\$name\$binaryPath")
    {
        Write-Info "$name already installed at ./bin."
        return
    }

    try
    {
        Invoke-WebRequest -Uri $url -OutFile $filename -ErrorAction Stop
    } catch
    {
        Write-Error "Failed to download $url"
        return
    }

    if ($filename -like "*.zip")
    {
        ExtractFileFromZip $filename $name $binaryPath
    } elseif ($filename -like "*.exe")
    {
        Install-Exe $filename $name
    } else
    {
        Write-Error "Unsupported file extension: $($filename.Substring($filename.LastIndexOf('.')))"
        return
    }

    Remove-Item $filename -Force
}

function ExtractFileFromZip($zipFile, $name, $binaryPath)
{
    try
    {
        Expand-Archive -Path $zipFile -DestinationPath $binPath/$name -Force -ErrorAction Stop
    } catch
    {
        Write-Error "Failed to extract $zipFile"
        return
    }

    Add-Path $name $((Get-Item $binPath\$name\$binaryPath).Directory)
    Write-Success "Successfully installed $name." 
}

function Install-Exe($fileName, $name)
{

}

function Add-Path($name, $path)
{
    try
    {
        Add-Content -Path $pathFile -Value "`$env:Path += `";$path`""
    } catch
    {
        Write-Error "Failed to add $name to $pathFile."
        return
    }
    $env:Path += ";$path"
}

function Main()
{
    Write-Title "Installing binaries"
    Write-Info "Installing binaries to $binPath"
    Write-Info "Adding paths to $pathFile"
    New-Item -ItemType Directory -Force -Path $binPath | Out-Null
    Install-Software "eza" "https://github.com/eza-community/eza/releases/download/v0.19.1/eza.exe_x86_64-pc-windows-gnu.zip" "eza.exe"
    Install-Software "lazygit" "https://github.com/jesseduffield/lazygit/releases/download/v0.43.1/lazygit_0.43.1_Windows_x86_64.zip" "lazygit.exe"
    Install-Software "gh" "https://github.com/cli/cli/releases/download/v2.55.0/gh_2.55.0_windows_386.zip" "bin\gh.exe"
    Install-Software "nvim" "https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-win64.zip" "nvim-win64\bin\nvim.exe"
    Install-Software "zoxide" "https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.4/zoxide-0.9.4-x86_64-pc-windows-msvc.zip" "zoxide.exe"
    Install-Software "delta" "https://github.com/dandavison/delta/releases/download/0.18.1/delta-0.18.1-x86_64-pc-windows-msvc.zip" "delta-0.18.1-x86_64-pc-windows-msvc\delta.exe"
    Install-Software "duf" "https://github.com/muesli/duf/releases/download/v0.8.1/duf_0.8.1_Windows_x86_64.zip" "duf.exe"
    Install-Software "dust" "https://github.com/bootandy/dust/releases/download/v1.1.1/dust-v1.1.1-x86_64-pc-windows-gnu.zip" "dust-v1.1.1-x86_64-pc-windows-gnu\dust.exe"
    Install-Software "fd" "https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-pc-windows-gnu.zip" "fd-v10.2.0-x86_64-pc-windows-gnu\fd.exe"
}

Main
