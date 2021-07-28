---
title: "Secure-Erasing"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---


## Shredding devices and files

With `shred`

The following writes zeros to `/dev/sda`

```sh
shred -vz -n0 /dev/sda
```

It is faster than using `/dev/zero` as `--random-source`:

```sh
# don't use this
shred -v -n1 --random-source=/dev/null /dev/sda
```

Shred uses an internel pseudo random generator which is faster than using
`/dev/urandom`. Also overwriting data once is usually sufficient today.

```sh
shred -v -n1 /dev/sda
```

## SSDs

Secure erase with `hdparm`. See [ata
wiki](https://ata.wiki.kernel.org/index.php/ATA_Secure_Erase). Also see [Solid
State Drive/Memory cell
clearing](https://wiki.archlinux.org/index.php/Solid_state_drive/Memory_cell_clearing)

```sh
hdparm -I /dev/sda
```

make sure the device is
- not **frozen**

If it is frozen, send system to sleep and wake it up. Check status again

```sh
echo -n mem > /sys/power/state
```

Then we set a security user password 

```
hdparm --user-master u --security-set-pass pass /dev/sda
# Make sure that it says `enabled` in the Security category
hdparm -I /dev/sda
```

Check if the device supports the "enhanced security erase"

```sh
Security:
...
        not     expired: security count
                supported: enhanced erase
        4min for SECURITY ERASE UNIT. 8min for ENHANCED SECURITY ERASE UNIT.
...
```

Issue the ATA Secure erase command

```sh
time hdparm --user-master u --security-erase pass /dev/sda

# If device supports "Enhanced security erase" use
time hdparm --user-master u --security-erase-enhanced pass /dev/sda
```

Now the "Security" feature should be disabled again. Check with `hdparm -I
/dev/sda` (should display `not enabled`)




