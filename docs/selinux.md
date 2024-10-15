SELinux
=======

Change the SELinux context of a directory

```sh
sudo mkdir /test
# add a context type to a path regex. saved in DB
sudo semanage fcontext -a -t user_home_dir_t "/test(/.*)?"
# apply/restore rules from DB
sudo restorecon -Rv /test
```

Search SELinux boolean `nis_enabled` where it is `-A` (allowed).

```sh
sesearch -b nis_enabled -A | grep -i sshd
```

List booleans and show short description

```sh
semanage boolean -l
```

List booleans with local customizations

```sh
semanage boolean -lC
```

Set a SEBoolean value

```sh
# -P writes the changes to the policy files, hence persisting them across reboots
setsebool -P nis_enabled 1
```


