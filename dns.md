# DNS

| Service                                 | IPv4            | IPv6                 |
| :-------------------------------------- | :-------------- | :------------------- |
| [Quad Nine](https://www.quad9.net)      | 9.9.9.9         | 2620:fe::fe          |
|                                         | 149.112.112.112 |                      |
| [Cloudflare and APNIC](https://1.1.1.1) | 1.1.1.1         | 2606:4700:4700::1111 |
|                                         | 1.0.0.1         | 2606:4700:4700::1001 |


## Query version

```sh
dig ch version.bind txt
# or
dig ch @1.1.1.1 version.bind txt 
```

