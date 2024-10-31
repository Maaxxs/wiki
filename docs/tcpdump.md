---
title: "Tcpdump"
---

Filter

```sh
tcpdump -i enp8s0 'tcp[13] & 4 != 0 && port 22'
# For RSTs:
tcpdump -i enp8s0 'tcp[13] & 4 != 0 and src port 22'
# For SYN-ACKs:
tcpdump -i eth0 'tcp[13] & 18 != 0 and src port 22'
```

nft table accounting

```sh
nft create table ip accounting
nft create chain ip accounting input { type filter hook input priority filter \; policy accept \; }
nft create chain ip accounting output { type filter hook output priority filter \; policy accept \; }

# And the the counter rule:
nft add rule ip accounting input tcp sport 22 tcp flags == syn\|ack counter

# Check the counts:
nft list table ip accounting
```


