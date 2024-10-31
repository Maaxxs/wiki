---
title: "Tcpdump"
---

Filter

```sh
tcpdump -i enp8s0 'tcp[13] & 4 != 0 && port 22'
```


