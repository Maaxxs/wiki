# Raspberry Pi

## Content

- [Reconnect to WiFi and start SSH after installing](#wifi-and-ssh)

### WiFi and SSH

**Goal**: You burn the Raspbian image to a SD-Card and want to enable SSH and a 
connection to your WiFi Access Point, so you don't need to connect an
Ethernat cable to your Raspberry Pi.

1. On your SD-Card: Go to `/boot/`
2. Create a file named `ssh`. This will start the SSH service
3. Create a file named `wpa_supplicant.conf` with following content:
  Edit the SSID and the PSK

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=DE

network={
    ssid="your-network-service-set-identifier"
    psk="your-network-WPA/WPA2-security-passphrase"
    key_mgmt=WPA-PSK
}
```

4. Save. Put the SD-Card into your Pi. Boot. Should connect to your WiFi.
5. TODO: Go back to some config file `/etc/netctl|net...`. Edit that configuration
  file and remove the clear text password. It's a commented line.
