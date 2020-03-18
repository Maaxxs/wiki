# Ubuntu

## Nextcloud

**Problem:** Nextcloud is asking for the password after
every login.

**Solution:** Connect Nextcloud to the password manager

```sh
snap connect nextcloud-client:password-manager-service
```

For more infos, see [here](https://forum.snapcraft.io/t/nextcloud-client-snap-doesnt-remember-password/4270)

## Timeout for add-apt-repository

1. Got to `/etc/gai.conf`
2. Remove the `#` in front of `precedence ::ffff:0:0/96 100`. This prefer
   IPv4 connections instead of IPv6. IPv6 will still work.

### Don't select the last audio device connected as output device automatically

in `/etc/pulse/default.pa` comment out

```conf
load-module module-switch-on-port-available


.ifexists module-switch-on-connect.so
load-module module-switch-on-connect
.endif
```

## Change grub settings

Save and select the last entry booted

Open the file `/etc/default/grub/`

```conf
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
GRUB_TIMEOUT=3
```

If you've got a 1920x1080 screen, change the resolution, if grub doesn't do automatically

```conf
GRUB_GFXMODE=1920x1080
```

Update the grub configuration

```bash
sudo update-grub
```

## Remove the two dashes in the signature of Evolution

Install the `dconf` editor and run

```sh
dconf write /org/gnome/evolution/mail/composer-no-signature-delim true
```

## Cisco anyconnect

```sh
sudo apt install network-manager-openconnect network-manager-openconnect-gnome
```

## Get sensors monitoring data

```sh
sudo apt install lm-sensors
```

Run `sensors-detect`. Usually it's safe to answer all questions with yes.
Put the found modules in `/etc/modules` and load these modules with
`sudo systemctl restart kmod`
