# Android

## Termux

### Essentials

```bash
pkg install x11-repo
pkg install git which curl build-essential unzip wget
```

### Git

```bash
ssh-keygen -t rsa -b 4096 -C "
cat ~/.ssh/id_rsa.pub
# Add to github

mkdir git
cd git
git clone https://github.com/mackeper/dotfiles.git
```

### Shell

```bash
pkg install zsh eza zoxide tmux fzf riggrep bat btop duf
chsh -s zsh

ln -s ~/git/dotfiles/linux/android/.zshrc ~/.zshrc
ln -s ~/git/dotfiles/linux/ubuntu/.tmux.conf ~/.tmux.conf
tmux
./.tmux/plugins/tpm/scripts/install_plugins.sh
```

### Languages

```bash
pkg install python nodejs

pip install pynvim
npm install -g neovim
```

### Neovim

```bash
pkg install neovim
mkdir -p ~/.config
ln -s ~/git/dotfiles/nvim ~/.config/nvim

### Fun

```bash
pkg install neofetch cmatrix
```
