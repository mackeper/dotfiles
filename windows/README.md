# Windows setup

![](.images/README/README_1698152733223.png)

## Install Chocolatey

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

```powershell
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
```

[Packages](https://chocolatey.org/packages)

## Apps

### Development

```powershell
choco install -y vscode
choco install -y neovim

choco install -y git
choco install -y mingw
choco install -y microsoft-windows-terminal
choco install act-cli # Run GitHub actions locally
choco install -y docker-desktop
choco install -y docker-compose

choco install -y nodejs
choco install -y sass
choco install -y elm-platform
choco install -y python
choco install -y rustup.install
choco install -y dotnet-sdk
```

#### Setup microsoft-windows-terminal

1. <https://www.nerdfonts.com/font-downloads> - Install Caskaydia Cove Nerd Font
2. Copy Microsoft.PowerShell_profile.ps1 to $PROFILE
3. Install modules:

```powershell
# looks
winget upgrade JanDeDobbeleer.OhMyPosh -s winget
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Install-Module -Name posh-git -Scope CurrentUser
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Install-Script winfetch # optional

# fzf
choco install -y fzf
Install-Module -Name PSFzf -Scope CurrentUser -Force
```

### Browsers

```powershell
choco install -y googlechrome
choco install -y firefox
choco install -y tor-browser
```

- [Thorium](https://github.com/Alex313031/Thorium-Win/releases)

### Communication

```powershell
choco install -y discord
```

### Media

```powershell
choco install -y spotify
choco install -y vlc
choco install -y adobereader
choco install -y obs-studio
```

### Gaming

```powershell
choco install -y steam-client
choco install -y epicgameslauncher
choco install -y ea-app
choco install -y ubisoft-connect
```

- [Riot Valorant](https://playvalorant.com/en-gb/)
- [Battle.net](https://www.blizzard.com/en-gb/apps/battle.net/desktop)

### Other

```powershell
choco install -y 7zip.install
choco install -y keepass.install
choco install -y f.lux

choco install -y powertoys
choco install -y bottom # htop for windows. Usage: btm
choco install -y ripgrep # grep for windows. Used by NeoVim. Usage: rg <text>
choco install -y autohotkey # Put file in startup folder

choco install -y protonvpn
choco install -y openvpn-connect

choco install -y rpi-imager
```
