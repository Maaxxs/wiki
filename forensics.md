# Forensics

## Filesystem creation date

Find out when a ext2/ext3/ext4 filesystem was created

```
sudo dumpe2fs /dev/sda1 | grep 'Filesystem created:'
```

