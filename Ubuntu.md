# Ubuntu

## Nextcloud

**Problem:** Nextcloud is asking for the password after
every login.

**Solution:** Connect Nextcloud to the password manager

``` sh
snap connect nextcloud-client:password-manager-service
```

For more infos, see [here](https://forum.snapcraft.io/t/nextcloud-client-snap-doesnt-remember-password/4270)
