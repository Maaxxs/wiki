---
title: "Borg"
date: 
tags: ["wiki"]
ShowLastUpdated: true
toc: true
draft: false
---


## Initialize the backup repository

```sh
# store key on local computer
borg init --encryption=keyfile raspistation:/backup/fedtow

# store key in config file on remote repo
borg init --encryption=repokey raspistation:/backup/fedtow
```

## Create an archive

Timestamp of `{now}`: 2020-05-17T12:26:56

```sh
borg create raspistation:/backup/testing::{now}_home_dir ~/Documents ~/Projects ~/Zotero
```

Using the date format `YYYY-MM-DD`

```sh
borg create raspistation:/backup/testing::{now:%Y-%m-%d} ~/Documents/ ~/Pictures/ ~/Projects/
```

## Listing contents

List the archives in the `/backup/testing` repo

```sh
$ borg list raspistation:/backup/testing
2020-05-17T12:26:56                  Sun, 2020-05-17 12:26:59 [d8ef941e6e7ab93f70fe9523d8a78cb08d4efa49977b4da95675a7ba128c3fc9]
2020-05-17T12:36:51_home_dir         Sun, 2020-05-17 12:36:54 [afda19941680998dfcf0f5928912f2ef5e844d4c9839b12ac1e3d8d142a613f0]
2020-05-17                           Sun, 2020-05-17 12:57:52 [a4e3440a06541673911a4769422222e4c6f6e522a0d144755231cde37de1e860]
```

List the contents of a specific archive `2020-05-17`

```sh
$ borg list --short  raspistation:/backup/testing::2020-05-17
home/max/Documents
home/max/Documents/fedora tweaks.md
home/max/Pictures
home/max/Projects
...
```

## Extracting content of archives

```sh
borg extract --dry-run --list raspistation:/backup/testing::2020-05-17T12:36:51 
```

Only extract the `home/max/Zotero` folder

```sh
borg extract raspistation:/backup/testing::2020-05-17T12:36:51_home_dir home/max/Zotero
```

