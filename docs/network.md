---
title: "Network"
date:
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# Network

## systemd-networkd

Create a file named `<something>.network`, eg `20-eth0.network`, in `/etc/systemd/network/`.
```toml
[Match]
Name=eth0

[Network]
DHCP=yes
```

You can specify multiple interfaces as well:
```toml
[Match]
Name=eth0
Name=eth1

[Network]
DHCP=yes
```

with static address:
```toml
[Match]
Name=eth0

[Network]
Address=10.1.10.9/24
Gateway=10.1.10.1
DNS=10.1.10.1
```

Restart the service `systemctl restart systemd-networkd`.

More information in the [archlinux
wiki](https://wiki.archlinux.org/title/Systemd-networkd)

## MAC Address Randomization with iwd (Internet wireless daemon)

MAC address randomization for every network to prevent tracking by WLAN
providers.

Put the following in `/etc/iwd/main.conf`:

```conf
[General]
AddressRandomization=network
AddressRandomizationRange=full
```

This will generate a new MAC for every network and it will always be the same
MAC for the same network. The option `full` randomizes all 6 octets of the MAC
address (other option is `nic`). See `man iwd.config` (5).

## In `interfaces` file

Edit `/etc/network/interfaces`.

With DHCP
```conf
auto eth0
iface eth0 inet dhcp
```

With static address
```conf
auto eth0
iface eth0 inet static
address 10.0.3.3
netmask 255.255.255.0
gateway 10.0.3.1
dns-nameservers 9.9.9.9
```

See also [linuxhint.com](https://linuxhint.com/debian_etc_network_interfaces/)


## Tethering via iPhone

Connect the iPhone via USB and make sure that [USBGuard](./usbguard.md) allows
the connection if you use it.

A new interface should show up with a name such as `enp0s20f0u1c4i2`. If that's
not the case you can try running `sudo idevicepair pair` to pair the iPhone.

Create a systemd-networkd config in `/etc/systemd/network/30-tethering.network`
with the following content:

```toml
[Match]
Name=enp0s20f0u1c4i2

[Network]
DHCP=yes
```

This will automatically pick up the new interface and get an IP address via
DHCP.


