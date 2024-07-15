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

# Automatically unlock default keyring with user password

The default keyring must have the same password as user login
([Arch Linux wiki][auto-unlock]).
In `/etc/pam.d/passwd` append the following line:

```
password        optional        pam_gnome_keyring.so
```

[auto-unlock]: https://wiki.archlinux.org/title/GNOME/Keyring#Automatically_change_keyring_password_with_user_password
