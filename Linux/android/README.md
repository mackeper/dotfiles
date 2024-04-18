# Android

## Termux

### Setup ubuntu

#### Essential packages

```bash
pkg install x11-repo
pkg install git which curl unzip wget proot-distro
proot-distro install ubuntu
```

#### Font

```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/CascadiaCode.zip
unzip CascadiaCode.zip -d CascadiaCode
mv CascadiaCode/CaskaydiaCoveNerdFont-Regular.ttf  ~/.termux/font.ttf # Move the regular.
rm -rf CascadiaCode CascadiaCode.zip
```

#### Create a new sudo user

```bash
proot-distro login ubuntu
```

See [Ubuntu](../ubuntu/README.md) for more information.

#### Access ubuntu

```bash
proot-distro login --user macke ubuntu
```

#### Install setup

```bash
curl -s https://raw.githubusercontent.com/mackeper/dotfiles/master/linux/ubuntu/install.sh | bash
```

See [Ubuntu](../ubuntu/README.md) for more information.

# Known issues

## Neovim / lazy

Might need to set `concurrency = 5` in `~/.config/nvim/lua/marcus/lazy.lua`.
