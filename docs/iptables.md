---
title: "Iptables"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# Iptables

[Why to use `REJECT` instead of `DROP`](http://www.chiark.greenend.org.uk/~peterb/network/drop-vs-reject)

## General

### Tables

Four tables
- `filter`    Filtering rules
- `nat`       NAT rules
- `mangle`    Special rules that alter packet data
- `raw`       Rules that should function independently of the Netfilter
              connection-tracking subsystem

### Matches
- `--source (-s)`       Match on a source IP address or network
- `--destination (-d)`  Match on a destination IP address or network
- `--protocol (-p)`     Match on an IP value
- `--in-interface (-i)` Input interface
- `--out-interface (-0)` Output interface
- `--state`             Match on a set of connection states.
                        `INVALID`, `ESTABLISHED`, `RELATED`
- `--string`            Match on a sequence of application layer data
                        bytes
- `--comment`           Associate up to 256 bytes of comment data
                        with a rule within kernel memory

### Targets
- `ACCEPT`  Packet continues on its way
- `DROP`    Drops a packet. The receiving stack will never see this
            packet and won't be able to send a `ICMP` message, for example.
- `LOG`     Logs a packet to syslog
- `REJECT`  Drops a packet. Send an appropriate response packet.
            (e.g. a TCP Reset packet for a TCP connection or an ICMP Port
            Unreachable message for a UDP packet)
- `RETURN`  Continue processing the packet within the calling chain



