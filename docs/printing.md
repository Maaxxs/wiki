## Print double-sided pages

How to print double-sided pages with a printer which doesn't explictely support
that mode.

1. Print only *even* pages in *reverse* order
2. Take the pages from the printer and turn them 180 degrees horizontally (pages
   usually come out of the printer head first and they need to go into the
   printer head first as well)
3. Print all *odd* pages.


## Setup on Arch Linux

I use `systemd-resolved` to resolve DNS queries. I disabled `mDNS`
support to prevent conflicts with Avahi. You can do so by setting
`MulticastDNS=no` in `/etc/systemd/resolved.conf.d/mydns.conf` (or in
the global `resolved.conf` file).

Install Avahi, `nss-mdns`, and the open source fork of `cups`.

```sh
pacman -S cups cups-pdf avahi nss-mdns
```

Make `nss-mdns` authoritative for the domain `.local` by adding
`mdns_minimal [NOTFOUND=return]` on the `hosts:` line in
`/etc/nsswitch.conf` before the `resolve ...` part:

```txt
hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
```

Start the services.

```sh
systemctl start cups avahi-daemon
# if you want to start and enable them permanently:
systemctl enable --now cups avahi-daemon
```

For a GUI to add and administrate printers:

```sh
pacman -S system-config-printer
```

Start the GUI, click Add. The networked printer should show up.

Check the official documentation for
[cups](https://wiki.archlinux.org/title/CUPS) and [hostname resolution
with Avahi](https://wiki.archlinux.org/title/Avahi#Hostname_resolution).

## HP

Avoid this company.
If you
[release security updates](https://support.hp.com/us-en/document/ish_11892982-11893015-16/hpsbpi03995)
on 29. January 2025 for CVE's dated from 2017 to 2023,
that's more than enough proof that you don't care about your customers.

* CVE-2017-12652 -- 9.8 Critical -- libpng -- Arbitrary Code Execution
* CVE-2022-2068 -- 9.8 Critical -- OpenSSL -- Arbitrary Code Execution
* CVE-2023-45853 -- 9.8 Critical -- zlib -- Information Disclosure
* CVE-2020-14152 -- 7.1 High -- libjpeg -- Denial of Service


