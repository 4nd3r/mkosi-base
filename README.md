# nspawn image with development tools

This is [`mkosi`](https://github.com/systemd/mkosi) configuration for building
an image containing development tools that I use daily but don't want to
clutter my system with due to various reasons.

Built image is compatible with [`nspawn`](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html).

Works for me on [Debian Sid](https://wiki.debian.org/DebianUnstable)
and (usually) with bleeding edge [`mkosi`](https://github.com/systemd/mkosi).

## Usage

```
make
sudo make install
machinectl shell $USER@tools
```
