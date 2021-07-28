---
title: "Android"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---


## Permissions errors

See <http://www.janosgyerik.com/adding-udev-rules-for-usb-debugging-android-devices/>

Get vender and product ID with `lsusb`

```sh
...
Bus 001 Device 008: ID 18d1:d002 Google Inc.
...
```

Create udev rule: `/etc/udev/rules.d/51-android.rules`

```conf
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="d002", MODE="0660",
GROUP="plugdev", SYMLINK+="android%n"
```

Add user to plugdev group

```sh
groupadd plugdev
usermod -a -G plugdev max
```
