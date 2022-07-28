# USBGuard

Install via pacman.

```sh
pacman -S usbguard
```

Generate policy:
```sh
sudo usbguard generate-policy > /etc/usbguard/rules.conf
```

After generating the config, start the daemon.
```sh
sudo systemctl enable --now usbguard
```

## USBGuard Notifier

This will show notifications for USB related events.

Install notifier.
```sh
yay -S usbguard-notifier
```

Edit the config of the usbguard-daemon to allow your user or the group `wheel`
access to the IPC socket and restart `usbguard`. The file is well documented;
see the [configuration in the web
here](https://usbguard.github.io/documentation/configuration).

In `/etc/usbguard/usbguard-daemon.conf`:

```conf
IPCAllowedGroups=wheel
```

Restart the service.
```sh
sudo systemctl restart usbguard
```

Enable usbguard-notifier service.
```sh
systemctl enable --user usbguard-notifier.service
```

Check for IPC connection errors in the **user** based log of usbguard-notifier
as well as the usbguard log.

```sh
journalctl -efu usbguard
journalctl --user -efu usbguard-notifier
```





