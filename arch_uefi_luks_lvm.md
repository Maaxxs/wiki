# Install Archlinux with LVM on LUKS

- with UEFI
- LVM on LUKS
- systemd-boot

## Boot ISO in UEFI mode

Check if booted in UEFI mode. If some content is displayed, then yes:

``` sh
ls /sys/firmware/efi
```

``` sh
# Create a EFI (ef00) partition of 512MiB size.
# Create a Linux LVM (8e00) parition of the rest.
gdisk /dev/sda

mkfs.fat -F32 /dev/sda1

cryptsetup luksFormat /dev/sda2

cryptsetup open --type luks /dev/sda2 lvm
```

## Create volumes

``` sh
pvcreate /dev/mapper/lvm
vgcreate arch /dev/mapper/lvm
lvcreate -L 8G arch -n swap
lvcreate -l 100%FREE arch -n root
```

## Create filesystems

``` sh
mkfs.ext4 /dev/arch/root
mkswap /dev/arch/swap
```

## Mount partitions and activate swap

``` sh
mkdir /mnt/boot
mount /dev/arch/root /mnt
mount /dev/sda1 /mnt/boot
```

## Install base system

### Chosse a good mirror

``` sh
vim /etc/pacman.d/mirrorlist
```

``` sh
# Add dialog and wpa_supplicant if installing on a laptop
pacstrap /mnt base base-devel bash-completion (dialog wpa_supplicant)
```

### Generate Fstab and chroot

``` sh
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
hwclock --systohc --utc
```

## Change root password

``` sh
passwd
```

## Add kernel hooks

You may need `FONT=lat9w-16` in `/etc/vconsole.conf` that the consolefont hook runs successfully.

``` sh
vim /etc/mkinitcpio.conf
```

``` conf
...
HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 filesystems resume fsck)
...
```

Generate a new ramdisk

``` sh
mkinitcpio -p linux
```

## Install systemd bootloader

``` sh
bootctl --path=/boot/ install
```

## Create loader config

``` sh
nvim /boot/loader/loader.conf
```

``` conf
default arch
timeout 2
console-mode max
editor 0
```

## Create boot entries

``` sh
vim /boot/loader/entries/arch.conf
```

For the intel microcode install the `intel-ucode` package.

"cryptdevice=... root=..." are on the **options** line!

in vim: `:r ! blkid` pastes the output into vim

``` conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options cryptdevice=UUID=123adf-1234asdf123-1234d-234fdfa:arch
options root=UUID=123-234
options resume=UUID=134-123 rw
```

arch-fallback.conf

``` conf
title   Arch Linux Fallback
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux-fallback.img
options cryptdevice=UUID=123adf-1234asdf123-1234d-234fdfa:arch
options root=UUID=123-234
options resume=UUID=134-123 rw
```

Follow normal guide [here](/archlinux#set-some-basic-stuff)
