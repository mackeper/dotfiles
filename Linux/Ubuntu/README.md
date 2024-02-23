# Ubuntu

## Shell

### Zsh

```bash
sudo apt install zsh
zsh --version
chsh -s $(which zsh) # Change default shell to zsh
```

### Zap (Zsh plugin manager)

```bash
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```

### Oh My Posh

```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
```

## Software

### Tools

```bash
sudo apt install build-essential
sudo apt install unzip
sudo apt-get install fuse libfuse2
```

### Programming

```bash
# Neovim, donno, download appimage from repo
# chmod u+x nvim.appimage

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Python
sudo apt install python3-pip
pip3 install --upgrade pip
pip3 install pynvim

# Node https://github.com/nodesource/distributions?tab=readme-ov-file#ubuntu-versions
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```
