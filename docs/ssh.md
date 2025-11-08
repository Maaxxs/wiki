# SSH

## Add port forwarding in a running SSH session

In the SSH client config `~/.ssh/config/` enable this mode.

```conf
EnableEscapeCommandline yes
```

Connect to the server, then type

```sh
# Open command line (C) in SSH via control character (default is tilde)
~C
# This opens the  ssh>  prompt. You can now enter forwarding commands.
ssh> -L 8080:127.0.0.1:80
```

Show the help of this mode with `~?`.

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

## Key verification

## On your server

Check the fingerprints with the keys on your server:

```sh
for key in /etc/ssh/ssh_host_*_key; do ssh-keygen -l -f $key; done
```

### Gitlab servers

- The website is kinda hidden: <https://gitlab.com/help/instance_configuration>

### Github servers

- <https://docs.github.com/en/github/authenticating-to-github/githubs-ssh-key-fingerprints>

## Show list of Host Key Fingerprints

```sh
ssh-keygen -l -f ~/.ssh/known_hosts
```

