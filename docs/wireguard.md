# Wireguard

- Also see [Wireguard Quick
  Start](https://www.wireguard.com/quickstart/)
- [Wireguard Config Generator](https://www.wireguardconfig.com/)

## Client Configuration

Set a stricter umask before generating a private and public key (you can
use `chmod` after generation, too):

```sh
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
```

Sample client configuration in `/etc/wireguard/wg0.conf`:

```conf
[Interface]
PrivateKey = privateKeyOfClient
Address = 10.0.0.4/24
DNS = 9.9.9.9
#ListenPort = 51820

[Peer]
PublicKey = publicKeyOfServer
AllowedIPs = 0.0.0.0/0
Endpoint = 185.207.105.60:51820
PersistentKeepalive = 25
```

- `Address`: address of the client in the VPN network with correct subnet!
- `DNS`: DNS server for client while tunnel is active.
- `AllowedIPs`: IPs to which the client is allowed to connect to. `0.0.0.0/0`
  means everything is routed through the tunnel.
- `Endpoint`: IP:PORT of the wireguard server.
- `PersistentKeepalive`: Send the sever a keepalive every 25s to keep the
  connection up. Especially useful if the client is behind a NAT.


You must have some `resolvconf` installed. If using `systemd-resolved`
for DNS on Arch Linux, install `systemd-resolvconf`, otherwise the
package `openresolv`.

## Enable on Boot

The client can be enabled by default on boot with:
```sh
systemctl enable wg-quick@wg0.service
```

