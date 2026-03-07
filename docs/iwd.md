# Iwd

## Automatically Connect to a VPN When Connected to Specific WLAN Network

Create a script that starts the VPN if the name of the connected WLAN network matches the one specified.

`$HOME/.local/bin/start-vpn.sh`

```sh
#!/usr/bin/env bash

echo "Running with id=$(id)"

if pgrep --exact openvpn; then
    echo "openvpn is already running. Exit"
    exit
fi

connected_network=$(iwctl station wlan0 show | grep "Connected network" | awk '{print $3}')

if [ "$connected_network" = "NAME_OF_NETWORK" ]; then
    sudo systemctl start openvpn-client@your-config
fi
```

Create a systemd path file to monitor a file that changes when we
connect to a new network.

`/etc/systemd/system/wifi_monitor.path`

```
[Unit]
Description=Monitor changes in Wifi connections

[Path]
# AFAICT, a .known_network.freq.xxxxx.tmp is created and renamed to the
# original file whenever a new connection is made.
PathChanged=/var/lib/iwd/.known_network.freq

[Install]
WantedBy=multi-user.target
```

Create the coresponding service file that should be started when a
change is detected.

`/etc/systemd/system/wifi_monitor.service`

```
[Unit]
Description=Start script to decide whether to start VPN

[Service]
Type=oneshot
User=YOUR_USER
Group=YOUR_USER
ExecStart=/home/YOUR_USER/.local/bin/start-vpn.sh

[Install]
WantedBy=multi-user.target
```

Enable the path unit.

```
systemctl enable --now wifi_monitor.path
```

