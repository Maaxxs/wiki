---
title: "Flatpak"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# Flatpak

- each application is build against a runtime. a runtime provides basic dependencies
- multiple runtimes (and versions of it) can be installed at the same time
- runtimes are distribution agnostic!

- each application brings its own dependencies if they are not in the runtime or if they need a different version of it
- each application is built and run in its own sandbox. Access to user files, etc. must be explicitly granted.

- portals: a way how applications can interact with the host system, e.g. a file chooser dialog or printing

- upgrading and downgrading is possible due to versioning and only the difference between versions id downloaded -> efficient! (like git)

- Identifier: `com.company.AppName` usually enough. More specific: `com.company.AppName/architecture/branch`

## Flatpak commands

flatpak commands are run system-wide by default. To run per-user: `--user` flag

- List remotes: `flatpak remotes`
- Add a remote (eg. flathub): `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`
- Remove a remote: `flatpak remote-delete flathub`

- search: `flatpak search gimp`
- install: `flatpak install flathub org.gimp.GIMP` (general: `flagpak install source app_id`
- uninstall: `flatpak uninstall org.gimp.GIMP`

Since Flatpak version 1.2, the `install` can search and install an application: `flatpak install gimp` works

- update all installed apps: `flatpak update`
- list installed apps: `flatpak list`

- remove runtimes and extensions that are not used by any installed applications: `flatpak uninstall --unused`
