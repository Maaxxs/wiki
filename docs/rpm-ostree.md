# RPM-ostree

Youtube 12min talk. [Let's try Fedora Silverblue — an immutable desktop OS](https://www.youtube.com/watch?v=-hpV5l-gJnQ)

## All or Nothing Upgrades

```sh
rpm-ostree upgrade
# reboot to switch to the new image
rpm-ostree status
rpm-ostree rollback
```

## Toolbox

Used to install packages -- or use the system in the "usual" way.

```sh
toolbox create
toolbox enter
```

## Podman

Similar to Docker but no root daemon.
The CLI is the same as Docker.

```sh
mkdir testdir
echo "hello world" > testdir/hello.txt
podman run --rm --it -v ~/testdir:/test fedora:30 bash
# in container:
ls /test/
# Permission denied error.
```
Fedora ships with SELinux by default.
Podman supports SELinux out of the box!
Add the `:Z` in the volume mount.

```sh
podman run --rm --it -v ~/testdir:/test:Z fedora:30 bash
# in container:
ls /test/
# works now
```

## Flatpaks

Used to run GUI software -- "containerized desktop apps in Fedora Silverblue".





