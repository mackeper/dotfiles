# Confirm version
$version = (curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.tag_name')
Write-Host "Latest Neovim version: $version"
$confirm = Read-Host "Proceed with download? [y/N]"
if ($confirm -ne 'y') { Write-Host "Aborted."; exit }

# Download the latest Neovim release for Windows 64-bit
wget $(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | `
  jq -r '.tag_name, (.assets[] | .browser_download_url)' | `
  grep "win64\.zip")

# Extract the zip file to C:\bin
Expand-Archive -Path "nvim-win64.zip" -DestinationPath "C:\bin\" -Force
Write-Host "Neovim extracted to C:\bin\nvim-win64"

# Cleanup
Remove-Item "nvim-win64.zip"
