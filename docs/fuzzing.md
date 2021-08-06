---
title: "Fuzzing"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# Fuzzing

## RAM disk for fuzzing to minimize writes on SSDs

Also see [this
post](https://www.cipherdyne.org/blog/2014/12/ram-disks-and-saving-your-ssd-from-afl-fuzzing.html)

```sh
# mkdir /tmp/afl-ramdisk && chmod 777 /tmp/afl-ramdisk
# mount -t tmpfs -o size=512M tmpfs /tmp/afl-ramdisk
```

Then move the project into the `afl-ramdisk` folder and start the fuzzing
process there.


