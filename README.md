# nspawn image with container tools

This is [`mkosi`](https://github.com/systemd/mkosi) configuration to build an image containing various tools for container building.

Built image is compatible with [`nspawn`](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html).

Works for me on [Debian Sid](https://wiki.debian.org/DebianUnstable) and (usually) with bleeding edge `mkosi`.

## Usage

```
make
sudo make install
machinectl shell $USER@ctools
```
