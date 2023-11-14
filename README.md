# my nspawn images

This is [`mkosi`](https://github.com/systemd/mkosi) configuration for building
[`nspawn`](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html)
images containing tools that I need, but don't want to clutter my system with.
Works for me on [Debian Sid](https://wiki.debian.org/DebianUnstable) and
usually with bleeding edge [`mkosi`](https://github.com/systemd/mkosi).

## Usage

```
NAME=docker make
sudo NAME=docker make install
machinectl shell $USER@docker
```
