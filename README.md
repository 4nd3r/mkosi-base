# nspawn image with development tools

This is [`mkosi`](https://github.com/systemd/mkosi) configuration to build an
image containing development tools which I use daily, but don't want to pollute
my system with due to various reasons.

Built image is compatible with [`nspawn`](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html).

Works for me on [Debian Sid](https://wiki.debian.org/DebianUnstable)
and (usually) with bleeding edge
[`mkosi`](https://github.com/systemd/mkosi/commit/19bb5e274d9a9c23891905c4bcbb8f68955a701d).

## Usage

```
make
sudo make install
machinectl shell $USER@tools
```
