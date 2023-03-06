# DNS

## DNS Server

| Service                                 | IPv4            | IPv6                 |
| :-------------------------------------- | :-------------- | :------------------- |
| [Quad Nine](https://www.quad9.net)      | 9.9.9.9         | 2620:fe::fe          |
|                                         | 149.112.112.112 | 2620:fe::9           |
| [Cloudflare and APNIC](https://1.1.1.1) | 1.1.1.1         | 2606:4700:4700::1111 |
|                                         | 1.0.0.1         | 2606:4700:4700::1001 |


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
