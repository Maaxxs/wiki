---
title: "Configure Ssh"
date: 
tags: ["wiki"]
ShowLastUpdated: true
toc: true
draft: false
---


## Initial configuration

1. Generate a keypair. Ed25519 uses Twisted Edwards curve

   ```sh
   ss-keygen -t ed25519
   ```

2. Copy generated public key to the server

   ```sh
   ssh-copy-id -i id_ed25519 USERNAME@IP-ADDRESS
   ```

3. Edit the server configuration file `/etc/ssh/sshd_config`

   ```conf
   Port 22
   PasswordAuthentication no
   PubkeyAuthentication yes
   ```
## Disable Debian Banner 

Example of returned banner

```conf
OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
```

Use `DebianBanner` option in `sshd_config` and set it to `no`.
```conf
DebianBanner no
```

You can test the configuration for errors with `sshd -t`.

Result:

```conf
OpenSSH 7.6p1 (protocol 2.0)
```
