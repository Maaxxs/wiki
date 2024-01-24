# Magic Wormhole Transit Relay

Run via Python environment:

```sh
pipenv install magic-wormhole-transit-relay
pipenv shell
twist transitrelay
```

Make sure TCP port 4001 is allowed in the firewall. E.g.

```sh
sudo ufw allow proto tcp from any to any port 4001
```

Then use

```sh
wormhole --transit-helper=tcp:your.host:4001 send somefile.md
wormhole --transit-helper=tcp:your.host:4001 receive ...
```

