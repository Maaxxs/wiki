---
title: "MacOS"
date:
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# MacOS

Check if apps are already supported for ARM:

* <https://isapplesiliconready.com/de>
* <https://doesitarm.com/>


## Get list of processor types of executable

```sh
lipo -archs $(which pdftex)
```

## Tmux coniguration with iterm2

set terminal to `xterm-256color` in `.tmux.conf`

```conf
set -g default-terminal "xterm-256color"
```

## Version

Display MacOS version and build version.

```sh
sw_vers
```

## Show Dynamically Linked Libraries of Executables

On linux it's `ldd`. On MacOS `otool` can be used.

```
otool -L /path/to/binary
```

## System Integrity Protection (SIP)

Show status:
```sh
csrutil status
```

We need to boot into the recovery mode to enable or disable settings.

- On a powered off M1, press and hold the power button until "Loading startup options" appears on the screen.
- On Intel: Hold <CMD+R> while booting.

To disable SIP but use Kext signing, DTrace restrictions, and BaseSystem Verification.

```
csrutil disable --with kext --with dtrace --with basesystem
```

## nvram

Show all firmware variables. Use (`-xp` for xml and `-Xp` for hex display format for the variable values).
```sh
nvram -p
```

Allow macOS to run non-Apple arm64e code.
```sh
sudo nvram boot-args=-arm64e_preview_abi
```

