# TLP - Power Management

```sh
pacman -S tlp
systemctl enable --now tlp
```

The Arch linux wiki suggests to mask these services to avoid conflicts
(with other services that interact with them, I guess?)

```sh
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket
```



