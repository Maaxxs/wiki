# OpenBSD

## Wireless configuration

Open `/etc/hostname.<interface>`, e.g. `/etc/hostname.wlan0`

lladdr = link layer address (MAC address)

```conf
lladdr random nwid <network name> wpakey "passphrase"
dhcp
```

For Ethernet only the second line for DHCP configuration is required.

Start the network service.

```sh
sh /etc/netstart
```


## Update

    doas fw_update
    doas sysmerge

system stats:

    systat

Update all packages

    pkg_add -u

Delete no longer needed dependencies

    pkg_delete -a

Get a list of installed packages

    pkg_info -mz > list

Install with

    pkg_add -l list


## Release Upgrade

1. `pkg_info -mz > installed_packages`
2. `sysupgrade`
3. Run `sysmerge` again after boot to merge configuration files that could not be merged automatically during boot
4. Check configuration changes
5. Remove old files if any
6. Check special package notes
7. `syspatch` (check errata page of release)
8. Update system packages `pkg_add -u`
9. Delete unneeded dependencies `pkg_delete -a`


## debug issues with X

- At the bootprompt do "boot -s"
- Enter on the "Enter pathname of shell or RETURN for sh" prompt
- mount /
- mount -a
- swapon -a
- rcctl disable xenodm
- exit
- Now log in and get the dmesg and the error that happens when you
  "rcctl -f start xenodm"

## OpenBSD version you're running

```sh
sysctl -n kern.version
```

```
OpenBSD X.Y-beta           = ongoing development *before* X.Y
OpenBSD X.Y with no suffix = release
OpenBSD X.Y-stable         = stable branch based on the X.Y release
OpenBSD X.Y-current        = ongoing development *after* X.Y
```

## Capturing traffic on a server

`-i` sets the interface, and `-s` sets the size parameter to the
maximum. Otherwise, only the first 116 bytes are captured by default.

```sh
doas tcpdump -i lo0 -w output.pcap -s 65535
```


## Interface configuration

```sh
doas ifconfig vio0 INTERFACE_IP/22
doas route add default GATEWAY_IP
```
