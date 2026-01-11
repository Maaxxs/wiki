# Packet Filter (PF)

```sh
# load file
pfctl -f /etc/pf.conf

# test configuration file. dry run
pfctl -nf /etc/pf.conf

# show stats
pfctl -s info

# show very detailed info
pfctl -s all
```
