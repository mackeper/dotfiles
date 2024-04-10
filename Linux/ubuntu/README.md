# Ubuntu

## Install essential packages

As root:

```bash
apt update
apt upgrade -y
apt install -y sudo software-properties-common vim curl
```

## Setup up a sudo user

```bash
adduser marcus
usermod -aG sudo marcus
echo 'marcus ALL=(ALL:ALL) ALL' >> /etc/sudoers
```

## Install setup

Install default setup:

```bash
curl -s https://raw.githubusercontent.com/mackeper/dotfiles/master/linux/ubuntu/install.sh | bash
```

To include fun packages like `neofetch` and `lolcat`:

```bash
curl -s https://raw.githubusercontent.com/mackeper/dotfiles/master/linux/ubuntu/install.sh | bash -s -- -f
```

Run help to see all available options:

```bash
curl -s https://raw.githubusercontent.com/mackeper/dotfiles/master/linux/ubuntu/install.sh | bash -s -- -h
```
