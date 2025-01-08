# PAM (Pluggable Authentication Modules)

## Control arguments

- sufficient
    - if true, return true
    - if false, continue
- requisite
    - if true, continue
    - if false, return false
- required
    - if true, continue
    - if false, continue but always return false

## Automatically Unlock Keyring when Logging in via Console

When using a display manager such as GDM, LightDM, ... this is not necessary.
They are already configured that way.

If you login via console, add the necessary PAM lines in `/etc/pam.d/login`.

> Add `auth optional pam_gnome_keyring.so` at the end of the auth section and
> `session optional pam_gnome_keyring.so auto_start` at the end of the session
> section.
>
> -- see the [Arch Linux wiki](https://wiki.archlinux.org/title/GNOME/Keyring#PAM_step)

The file `/etc/pam.d/login` should look like this:

```conf
#%PAM-1.0

auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so    # <--- this
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start   # <--- this
```


## Automatically Change Keyring Password with User Password

See [Arch Linux wiki][auto-unlock].
In `/etc/pam.d/passwd` append the following line:

```
password        optional        pam_gnome_keyring.so
```

[auto-unlock]: https://wiki.archlinux.org/title/GNOME/Keyring#Automatically_change_keyring_password_with_user_password

## Remove Delay After Failed Authentication in Sudo

Add the `nodelay` option in `/etc/security/faillock.conf` on its own line.
This enables that the `nodelay` option of the `pam_unix.so` module is actually respected.

In `/etc/pam.d/sudo` replace the line

```
auth           include         system-auth
```

with the lines referring to `auth` (a PAM stack) found the `/etc/pam.d/system-auth` file.
Then add the `nodelay` option for the `pam_unix.so` module.
The content of `/etc/pam.d/sudo` should be the following.

```text
#%PAM-1.0

auth       required                    pam_faillock.so      preauth
-auth      [success=2 default=ignore]  pam_systemd_home.so
auth       [success=1 default=bad]     pam_unix.so          try_first_pass nullok nodelay
auth       [default=die]               pam_faillock.so      authfail
auth       optional                    pam_permit.so
auth       required                    pam_env.so
auth       required                    pam_faillock.so      authsucc

# other already existing lines not referring to type auth
account         include         system-auth
session         include         system-auth
```

That's it.

Why not add the `nodelay` option in `/etc/pam.d/system-auth`?
Because all other modules that delegate to that `/etc/pam.d/system-auth` file would inherit the `nodelay` option as well.
This is not what we want.
For instance, the `sshd` service also delegates to the `system-auth` file and would therefore inherit that behaviour.
We want to keep the change concisely where we want it to be: only applied to the `sudo` program.

