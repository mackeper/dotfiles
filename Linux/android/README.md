# Android

## Termux

### Setup ubuntu

#### Essential packages

```bash
pkg install x11-repo
pkg install git which curl unzip wget proot-distro
proot-distro install ubuntu
proot-distro login ubuntu
```

#### Font

```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/CascadiaCode.zip
unzip CascadiaCode.zip -d CascadiaCode
mv CascadiaCode/CascadiaCode.ttf ~/.termux/font.ttf # Move the regular.
```

#### Access ubuntu

```bash
proot-distro login --user macke ubuntu
```

#### Install setup

```bash
curl -s https://raw.githubusercontent.com/mackeper/dotfiles/master/linux/ubuntu/install.sh | bash
```

See [Ubuntu](../ubuntu/README.md) for more information.
