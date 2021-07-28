---
title: "Raspberrypi"
date: 
tags: ["wiki"]
ShowLastUpdated: true
toc: true
draft: false
---


## Enable WLAN

Go to the directory `/boot/` on the SD card and create a file called
`wpa_supplicant.conf` with the following content.

Edit the value of `country`, `ssid` and `psk`.

```conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=DE

network={
    ssid="your-network-service-set-identifier"
    psk="your-network-WPA/WPA2-security-passphrase"
    key_mgmt=WPA-PSK
}
```

Save the file and boot your pi.

Note: Go back to some config file in `/etc/netctl|net...`. Edit that
configuration file and remove the clear text password. It's a commented line.

## Enable SSH

Create a file called `ssh` in `/boot/` of your SD card. That's it.

## Change username `pi` to `michael`

Connect as root to your raspberry pi. This can be enabled by changing the
`PermitRootLogin` option to `yes` in `/etc/ssh/sshd_config` and reloading the
SSH daemon `sudo systemctl restart sshd`.

```conf
PermitRootLogin yes
```

Then execute as root

```sh
usermod -l michael -d /home/michael -m pi
groupmod --new-name michael pi
```

Disable root login in `/etc/ssh/sshd_config`.

## "Disable" root account

To disable the root account

```sh
sudo passwd -l root
```
