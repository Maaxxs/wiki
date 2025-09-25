# TCP

## TCP Congestion Control

Default is likely `cubic` if you're using Linux.

```sh
sysctl net.ipv4.tcp_congestion_control
```

Load `tcp_htcp` and activate it with `htcp`.

```sh
modprobe tcp_htcp
sysctl -w net.ipv4.tcp_congestion_control=htcp
```


