---
title: "UFW"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# UFW

## Add rules

Add tcp on port 22 and only IPv4 (address specified)

```sh
ufw allow proto tcp to 0.0.0.0/0 port 22
```

## List rules with number

```sh
ufw status numbered
```

## Delete rule

```sh
sudo ufw delete 5
```
