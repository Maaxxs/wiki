---
title: "Fedora"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---


To use the command `chsh`, install

    util-linux-user

## Nextcloud

Nextcloud asks for the password after every login sometimes only after reboot. Installing

    libgnome-keyring

fixed this after adding the credentials one more time.

## Grub

[Set default entry](https://docs.fedoraproject.org/en-US/fedora/rawhide/system-administrators-guide/kernel-module-driver-configuration/Working_with_the_GRUB_2_Boot_Loader/)

in `/etc/default/grub`

```conf
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
```

To update the grub settings for UEFI systems

```sh
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
```

## Fonts

Installing the Noto Sans fonts (mono, serif and display font)

```sh
sudo dnf install google-noto-sans-mono-fonts google-noto-serif-display-fonts google-noto-sans-display-fonts
```
