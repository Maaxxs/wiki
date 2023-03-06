# DNS

## DNS Server

| Service                                 | IPv4            | IPv6                 |
| :-------------------------------------- | :-------------- | :------------------- |
| [Quad Nine](https://www.quad9.net)      | 9.9.9.9         | 2620:fe::fe          |
|                                         | 149.112.112.112 | 2620:fe::9           |
| [Cloudflare and APNIC](https://1.1.1.1) | 1.1.1.1         | 2606:4700:4700::1111 |
|                                         | 1.0.0.1         | 2606:4700:4700::1001 |


## Configure `systemd-resolved`

The following configuration file will

- enable DNS over TLS
- DNSSEC where enabled
- use quad9 DNS servers with cloudflare as fallback

Create the configuration file `/etc/systemd/resolved.conf.d/mydns.conf` with
the following content:

```conf
[Resolve]
DNS=9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
FallbackDNS=1.1.1.1#cloudflare-dns.com
# Use the here configured DNS servers, even if a per-link DNS server sets the
# domain to ~. as well. More specific queries will go to the per-link DNS server
Domains=~.
DNSSEC=true
DNSOverTLS=yes
#MulticastDNS=yes
#LLMNR=yes
#Cache=yes
#CacheFromLocalhost=no
#DNSStubListener=yes
#DNSStubListenerExtra=
#ReadEtcHosts=yes
#ResolveUnicastSingleLabel=no
```

For the default options check the file `/etc/systemd/resolved.conf` and the
manpage with `man resolved.conf`.

## Query version

```sh
dig ch version.bind txt
# or
dig ch @1.1.1.1 version.bind txt
```

## Dump DNS Cache

If `systemd-resolved` is used, you can dump the current DNS cache.

Follow the unit in the journal with:
```sh
journalctl -f -u systemd-resolved
```

Then dump the cache with this command.
```sh
sudo killall -USR1 systemd-resolved
```

## Flush DNS Cache

```sh
systemd-resolve --flush-caches
```

## Show Statistics

```sh
systemd-resolve --statistics
```

## Monitor DNS Requests

```sh
sudo resolvectl monitor
```
