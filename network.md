# Network configuration

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



