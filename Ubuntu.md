# Ubuntu

## Nextcloud

**Problem:** Nextcloud is asking for the password after
every login.

**Solution:** Connect Nextcloud to the password manager

``` sh
snap connect nextcloud-client:password-manager-service
```

For more infos, see [here](https://forum.snapcraft.io/t/nextcloud-client-snap-doesnt-remember-password/4270)


## Timeout for add-apt-repository

1. Got to `/etc/gai.conf`
2. Remove the `#` in front of `precedence ::ffff:0:0/96  100`. This prefer
IPv4 connections instead of IPv6. IPv6 will still work.

