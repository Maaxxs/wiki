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

### Network Configuration

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

### MAC Address Randomization with systemd.link file

The following configuration will randomize the MAC addresses of the matched
interfaces on boot time (does not work when just restarting
`systemd-networkd`).

Create a `something.link` file in `/etc/systemd/network/`, e.g.
`/etc/systemd/network/90-all.link`. The name starts with `90...` because I set
the "default" for the interfaces. Quote from manpage:

> The first (in alphanumeric order) of the link files that matches a
> given interface is applied, all later files are ignored, even if they
> match as well.

So, the default will be to randomize the MAC address as shown in the next
configuration block, but I could create another link file starting with number
below `90`, which would take precedence at any time, e.g. if I wanted to create
a static spoofed MAC address and not a randomized one. (I'm already taking
precedence with my custom `.link` file. Take a look at the
`/usr/lib/systemd/network/99-default.link` file.)

Content of `/etc/systemd/network/90-all.link`:

```conf
[Match]
# Mach all interfaces with:
OriginalName=*
# one or more explicit hardware MAC addresses where this configuration should match
#PermamentMACAddress=aa:bb:cc:dd:ee:ff 12:34:56:78:90:ab

[Link]
#MACAddress=<fixed-spoofed-mac>
MACAddressPolicy=random
```

See `man systemd.link` (5).

This works for the ethernet interface. As I'm using `iwd` for WLAN, see [the
next section](#mac-address-randomization-with-iwd), which is a simple 3-line
configuration.


## MAC Address Randomization with iwd

This configuration randomizes the MAC address at every (re)start of iwd
(Internet wireless daemon) to prevent tracking by WLAN providers.

Put the following in `/etc/iwd/main.conf`:

```conf
[General]
AddressRandomization=once
AddressRandomizationRange=full
```

If you want to generate a MAC address for every network, which will be
consistent accross restarts of iwd as well, use `AddressRandomization=network`.
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


