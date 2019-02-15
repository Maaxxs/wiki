# Install Arch

- with UEFI
- LVM on LUKS
- systemd boot

#### Check if booted in UEFI mode. If some content is displayed, then yes:

```
ls /sys/firmware/efi
```

```
# Create a EFI (ef00) partition of 512MiB size.
# Create a Linux LVM (8e00) parition of the rest.
gdisk /dev/sda

mkfs.fat -F32 /dev/sda1

cryptsetup luksFormat /dev/sda2

cryptsetup open --type luks /dev/sda2 lvm

pvcreate /dev/mapper/lvm
vgcreate main /dev/mapper/lvm
lvcreate -L 20G main -n root
lvcreate -l 100%FREE main -n home

mkfs.ext4 /dev/mapper/main-root -L ROOT
mkfs.ext4 /dev/mapper/main-home -L HOME

mkdir /mnt/home
mkdir /mnt/boot

mount /dev/mapper/main-root /mnt
mount /dev/mapper/main-home /mnt/home
mount /dev/sda1 /mnt/boot

# Add dialog and wpa_supplicant if installing on a laptop
pacstrap /mnt base base-devel bash-completion neovim (dialog wpa_supplicant)

genfstab -Up /mnt >> /mnt/etc/fstab

arch-chroot

hwclock --systohc --utc

# Change root password
passwd

# Add hooks
nvim /etc/mkinitcpio.conf
HOOKS=(base udev autodetect keyboard modconf block encrypt lvm2 filesystems fsck)
mkinitcpio -p linux

bootctl --path=/boot/ install

nvim /boot/loader/loader.conf
default arch
timeout 2
editor 0

# "cryptdevice=... root=..." are on the "options" line!
nvim /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options cryptdevice=UUID=123adf-1234asdf123-1234d-234fdfa:main root=/dev/mapper/main-root rw

nvim /boot/loader/entries/arch-fallback.conf
title   Arch Linux Fallback
linux   /vmlinuz-linux
initrd  /initramfs-linux-fallback.img
options cryptdevice=UUID=123adf-1234asdf123-1234d-234fdfa:main root=/dev/mapper/main-root rw

# uncomment 'en_US...'
neovim /etc/locale.gen
locale-gen
locale > /etc/locale.conf


# Change hostname
nvim /etc/hostname

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo KEYMAP=us > /etc/vconsole.conf

# Add user
useradd -m -g users -G wheel,audio,video -s /bin/zsh max
passwd max

# Remove '#' in front of %wheel All = (ALL) ALL
EDITOR=nvim visudo

# Make sure, you can sudo into root. Then disable root login
passwd -l root

exit
umount -R /mnt
reboot
```

#### Login with root and configure system

```
pacman -S acpid ntp avahi
systemctl enable acpid ntpd avahi-daemon
ntpq -gq

# Install graphics driver
pacman -S xf86-video-intel

# Install Desktop
pacman -S xorg-server xorg-xinit xfce4 xfce4-goodies lightdm networkmanager network-manager-applet nm-connection-editor git
systemctl enable lightdm NetworkManager

# Install slick-greeter for lightdm
git clone https://aur.archlinux.org/lightdm-slick-greeter.git
cd lightdm-slick-greeter
makepkg -rsi
cd .. && rm -rf lightdm-slick-greeter

# Install audio tools
pacman -S alsa-tools alsa-utils pulseaudio-alsa pavucontrol

reboot
```

#### You should be able to login with your username into a graphical environment
```
# Switch to german layout while right-alt-key is pressed.
localectl set-x11-keymap us,de ,pc105 ,nodeadkeys grp:switch

# Install gufw as firewall manager
pacman -S gufw
ufw enable

# Install window themes, icon themes, applications, ...
pacman -S ttf-hack noto-fonts arc-icon-theme arc-gtk-theme 
```

#### Customize your system and have fun