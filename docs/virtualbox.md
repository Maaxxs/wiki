# Virtualbox

## Option 1: Shrink VDI disk using `dd`

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

## Option 2: Shrink VDI disk using `zerofree`

1. Start the VM and delete anything you don't need in the VM.
2. Make sure you can edit command line parameters on boot.
3. When starting the VM, hit `Esc` repeatedly (grub) or hold `space` for the
   systemd boot menu to show up.
4. Press `e` to edit the parameters and append an `init=/bin/bash` to the
   command line arguments.
5. Continue boot. You'll land the a bash shell. 
6. Remount the root filesystem: `mount -n -o remount,ro -t ext4 /dev/sda1 /`
7. Finally run `zerofree -v /dev/sda1`
8. When finished, shutdown with `halt`

In the last step we run the `VBoxManage` command to shrink the VDI disk.

```sh
VBoxManage modifymedium disk ./diskname.vdi -compact
```

