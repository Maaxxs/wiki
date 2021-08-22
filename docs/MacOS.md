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

    lipo -archs $(which pdftex)

## Tmux coniguration with iterm2

set terminal to `xterm-256color` in `.tmux.conf`

```conf
set -g default-terminal "xterm-256color"
```
