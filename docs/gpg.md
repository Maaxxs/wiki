---
title: "GPG"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# GPG

## Use with Thunderbird

With Gnome put the following in `~/.gnupg/gpg-agent.conf` so that thunderbird
actually uses a graphical prompt to display the request for the password of the
key. Otherwise thunderbird fails silently.

```
pinentry-program /usr/bin/pinentry-gnome3
```


## Storage and backup

Optional: Make archive of folder

```sh
tar czf gpg-backup.tgz gpg-backup
```

Encrypt it symmetrically with gpg

```sh
gpg -o gpg-backup.tgz.gpg --symmetric gpg-backup.tgz 
```

This can be decrypted by running the following command and entering the password
used for the symmetric encryption.

```sh
gpg gpg-backup.tgz.gpg
```

