# Android

## Termux

### Setup ubuntu

```bash
pkg install x11-repo
pkg install git which curl unzip wget proot-distro
proot-distro install ubuntu
proot-distro login ubuntu
```

```bash
apt update
apt install software-properties-common sudo vim
adduser macke
visudo # Add macke to sudoers
```

```bash
proot-distro login --user macke ubuntu
```
