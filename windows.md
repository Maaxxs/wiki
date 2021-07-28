---
title: "Windows"
date: 
tags: ["wiki"]
ShowLastUpdated: true
toc: true
draft: false
---


## Create a bigger ESP partition (default 100MB)

[Source](https://superuser.com/questions/1308324/create-efi-partition-before-installing-windows-10)

1. Boot Windows installer
2. Press `Shift+F10` to open command line
3. Type `diskpart`
4. Type `list disk`. All disks will be printed. Note the number of your disk (most likely `0`. Select it with `select disk 0`
5. Create ESP: `create partition efi size=512` (512MiB)
6. Exit diskpart: `exit`
7. Continue installation
