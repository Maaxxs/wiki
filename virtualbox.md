# Virtualbox

## Shrink VDI disk

1. Start the VM and delete anything you don't need in the VM.
2. Then create a file with just zeros.
3. Run `sync` and delete the file.

```sh
dd if=/dev/zero of=junk
sync
rm junk
```

4. Poweroff the VM and navigate to the folder containing the disk on the host 
and run the following command.

```sh
VBoxManage modifymedium disk ./diskname.vdi -compact
```

