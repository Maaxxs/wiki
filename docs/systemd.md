---
title: "Systemd"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# Systemd

Build dependency graph. The package `graphviz` is required.
```sh
systemd-analyze dot | dot -Tsvg > systemd.svg
```

Show the systemd configuration paths (with precedence)
```sh
systemctl -p UnitPath show
```

List cgroups with 
```sh
systemd-cgls
```

List jobs
```sh
systemctl list-jobs
```

Show properties of a unit or only a specific property of a unit
```sh
systemctl show unit
systemctl show -p type unit
```

For example, `sshd` is wanted by `multi-user.target`
```
$ systemctl show -p WantedBy sshd
WantedBy=multi-user.target
```

## Unit types

`Type=` is one of

| Type      | Description |
| :-        | :-          |
| `simple`  | TODO
| `forking` |
| `notify`  |
| `dbus`    |
| `oneshot` |
| `idle`    |

## Dependencies

`Wants` should be the default because the actual unit will not fail even if the
dependency fails which results in a more robust system.

| Keyword     | Description                                                                                              |
| :-          | :-                                                                                                       |
| `Requires`  | strict. If dependency fails the, unit fails.                                                             |
| `Wants`     | If dependency fails, the unit is still activated.                                                        |
| `Requisite` | Dependency must already be running, otherwise the unit fails to activate.                                |
| `Conflicts` | The conflicted unit is deactivated if it's active. A simultaneous activation of conflicting units fails. |

Instead of specifying a direct dependency in the unit itself, a dependency for a
unit can also be specified in another unit (so in the dependency unit). This
offers the advantage that when new units are added, only this new unit has to be
edited and can specify itself as a dependency for an existing unit without
modyfing that existing unit.

| Keyword      | Description                                                               |
| :-           | :-                                                                        |
| `WantedBy`   | See `Wants`. if this dependency fails, the other unit is still activated. |
| `RequiredBy` | See `Requires`. A strict dependency.                                      |


TODO: unit types explanation
TODO: p143 specifiers





