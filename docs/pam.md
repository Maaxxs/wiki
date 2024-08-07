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

