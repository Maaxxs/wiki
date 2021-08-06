---
title: "Fedora"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# Fedora

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

## Tweaks

<!-- ## Removing local calendars -->
<!-- delete local personal and birthday calendar -->
<!-- in .config/evolution/sources -->
<!-- remove the birthdays.source  system-calendar.source -->
<!-- nope. does not work. -->


### Remove managed thing in chrome

```sh
sudo dnf remove fedora-chromium-config
```

### Install rpm fusion free and non-free repos

```sh
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

GPG keys here: <https://rpmfusion.org/keys>

### Install fira code

```sh
dnf install fira-code-fonts
```

### Dash to dock

```sh
dnf install gnome-shell-extension-dash-to-dock
```

Log out and back in to activate it in the Gnome extension app

### install vs code

Import public key of microsoft

```sh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```

Add `vscode.repo` in `/etc/yum.repos.d/` 
```sh
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
```

Then update and install vs code
```sh
sudo dnf check-update
sudo dnf install code
```

### Install nextcloud client and the nautilus integration

```sh
sudo dnf install nextcloud-client nextcloud-client-nautilus 
```




