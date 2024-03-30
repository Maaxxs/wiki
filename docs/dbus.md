D-Bus
=====

messsage

* unit of data transfer
* message header + data
* header
  * sender
  * receiver
  * message type
    * signal
    * method call
    * method return
    * error


See this for addressing and meaning of bus, connection, object,
interface, member.

<https://freedesktop.org/wiki/IntroductionToDBus/#addressing>

List all registered(?) names on the session dbus:

```
dbus-send --session --print-reply --type=method_call --dest=org.freedesktop.DBus / org.freedesktop.DBus.ListNames

dbus-send --system --print-reply --type=method_call --dest=org.freedesktop.hostname1 /org/freedesktop/hostname1 org.freedesktop.DBus.Properties.GetAll string:"org.freedesktop.hostname1"
```

similiar with `busctl`

```
busctl --user tree org.freedesktop.impl.portal.desktop.wlr
busctl --user introspect org.freedesktop.DBus /org/freedesktop/DBus
```

D-Bus Message Format
--------------------

* y: byte
* u: uint32
* a: array
* v: variant
* (): struct

```
yyyyuua(yv)

byte, byte, byte, byte, uint32, uint32, array of struct of (byte, variant)
```

D-Bus Signals
-------------

* implement 1:N publisher:subscriber
* async
* must request to be notified about messages via match rules


Note on Systemd Transient Units
-------------------------------

systemd-run: transient unit files

```
$ systemd-run --user env
Running as unit: run-r1e1f1343f5194d9a9d7a1f17c01d9172.service; invocation ID: 7b56703067094c36a142ce130331c10e

$ journalctl --user -u run-r1e1f1343f5194d9a9d7a1f17c01d9172.service
Mar 30 12:21:58 hostname systemd[1236]: Started /usr/bin/env.
Mar 30 12:21:58 hostname env[53631]: HOME=/home/user
Mar 30 12:21:58 hostname env[53631]: LANG=en_US.UTF-8
Mar 30 12:21:58 hostname env[53631]: LANGUAGE=en_US
[...]
```

