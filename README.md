# my nspawn images with different tools

This is [`mkosi`](https://github.com/systemd/mkosi) configuration for building
different images containing various tools that I need, but don't want to
clutter my system with due to various reasons.

Images is compatible with [`nspawn`](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html).

Works for me on [Debian Sid](https://wiki.debian.org/DebianUnstable)
and (usually) with bleeding edge [`mkosi`](https://github.com/systemd/mkosi).

## Usage

```
NAME=docker make
sudo NAME=docker make install
machinectl shell $USER@docker
```
