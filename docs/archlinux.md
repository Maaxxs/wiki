# Archlinux

## Copy ISO on USB

Download archlinux ISO. If you are currently on an archlinux machine, you can
check the signature with

```sh
pacman-key -v archlinux.iso.sig
```

otherwise

```sh
gpg --verify archlinux.iso.sig
```

If you need to download the key used for signing the image, use

```sh
# if the key with id 4AA4767BBC9C4B1D18AE28B77F2D434B9741E8AC was used
gpg --recv-keys 4AA4767BBC9C4B1D18AE28B77F2D434B9741E8AC
```

Write to USB drive `/dev/sdX` as root:

```sh
dd bs=4M if=./archlinux.iso of=/dev/sdX conv=fsync oflag=direct status=progress
```

## Install Archlinux

This will be an archlinux installation with systemd-boot (EFI) and LVM in a LUKS
encrypted container.

You might want to override your harddrive, especially if you want to encrypt it.

```sh
# Parameter -n: how many times?
shred –verbose –random-source=/dev/urandom -n1 /dev/sdX
```

For a german keyboard layout

```sh
loadkeys de
```

Connect to the internet via wlan with `iwd`. Get the interactive prompt with:
```sh
iwctl
```

Device list
```
[iwd]# device list
```

Let's assume the wlan device is called `wlan0`. Scan and list networks:
```
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks
```

Connect to a network:
```
[iwd]# station wlan0 connect <SSID>
```


### Create filesystems and activate swap

You can check if you booted in efi mode: if the following command lists some
content then you did.

```sh
ls /sys/firmware/efi
```

Partition of the drive:

- Create a EFI (`ef00`) partition of 512MiB size (if you've got a windows
  installation you can use the Windows EFI partition if it's big enough which
  should usually be the case).
- Create a Linux (can be the LUKS type `8309`) parition of the rest.

```sh
gdisk /dev/sda
```

Format efi partition (sda1) and create and open the luks container.

```sh
# create file system for the efi partition
mkfs.fat -F32 /dev/sda1

cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 luks
```

I want hibernation to be available so a swap partition must be created.

```sh
pvcreate /dev/mapper/luks
vgcreate arch /dev/mapper/luks
lvcreate -L 8G arch -n swap
lvcreate -l 100%FREE arch -n root
```

Create the `ext4` filesystem. Create and activate the swap.
```sh
mkfs.ext4 /dev/arch/root

mkswap /dev/arch/swap
swapon /dev/arch/swap
```

**The following only applies if the pysical sector size of your drive/SSD if
larger than 512MiB.** Otherwise jump ahead to [mount all
partitions](#mount-all-partitions).

If the SSD/HDD uses 4096 bytes as physical sector size, you probably want to
set the sector size to 4096 in the `cryptsetup` command and in the filesystem
creation command. This can be checked with `hdparm -I /dev/sda | grep 'Sector
size'`

```sh
# use sector size of 4096
cryptsetup luksFormat --sector-size 4096 /dev/sda2
```

After creating the ext4 filesystem, the block size is usually choosen
correctly. You can verify this after creating the ext4 filesystem with

```sh
sudo dumpe2fs /dev/arch/root | grep 'Blocksize'
```

If it is not correct, you may force a sector size of 4096 with

```sh
mkfs.ext4 -F -b 4096 /dev/arch/root
```

### Mount all partitions

```sh
mount /dev/arch/root /mnt

mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

### check mountpoints and swap
```sh
df -Th
# check swap
free -h
```

### Chosse a good mirror

```sh
vim /etc/pacman.d/mirrorlist
```

### Install Base system

```sh
# Add dialog and wpa_supplicant if installing on a computer connected via wlan.
pacstrap /mnt base base-devel linux linux-firmware intel-ucode bash-completion (iwd)
```

### Generate File system Table

```sh
genfstab -U /mnt >> /mnt/etc/fstab
# check with: cat /mnt/etc/fstab
```

### Enter your system

```sh
arch-chroot /mnt
```

### Synchronize hardware clock if you'd like
```sh
hwclock --systohc --utc
```

### Add kernel hooks
```sh
vim /etc/mkinitcpio.conf
```

For the `lvm2` hook the package `lvm2` is needed which can be installed in
the chroot with `pacman -S lvm2`. The `resume` hook is needed for hibernation.

```conf
...
HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems resume fsck)
...
```

Generate a new ramdisk

```sh
mkinitcpio -p linux
```


### Set some basic stuff

- `/etc/hostname`

```sh
# Hostname
hostname
```

- `/etc/locale.conf` (choose language)

```sh
# german
LANG=de_DE.UTF-8
LANGUAGE=de_DE

# english
LANG=en_US.UTF-8
LANGUAGE=en_US
```

- `/etc/vconsole.conf` (choose layout)

```sh
# Font on early boot
FONT=lat9w-16
# german layout
KEYMAP=de-latin1-nodeadkeys
# us layout
KEYMAP=us
```

### Set the Time Zone

```sh
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```

### Add a user

- _@param -m: create home directory_
- _@param -G: other groups_
- _@param -s: Shell._ Default is `/bin/bash`

```sh
useradd -m -G wheel username
# Set password for your user
passwd username
```

### Change the root password

```sh
passwd
```

### Allow members of group wheel to gain root priviliges

For `nvim`, install `pacman -S neovim`

```sh
EDITOR=nvim visudo

# remove the '#' in the line:
%wheel ALL=(ALL:ALL) ALL
```

### Edit and generate the locales

```sh
# eg: remove '#' in front of all 'de_DE' or 'en_US' entries
nvim /etc/locale.gen

# generate
locale-gen
```


### Grub on BIOS - Legacy systems

**Ignore this. Legacy. I don't use it anymore. It's just there for reference.
Jump to [Systemd-boot](#systemd-boot-on-uefi-systems)**

#### Installation of `grub` and `os-prober`

```sh
# Install Grub and os-prober to detect other installed operating systems if you have any
pacman -S grub os-prober
grub-install /dev/sda
```

#### Generate Grub configuration

```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

### Systemd Boot on UEFI systems

if the efi partition was mounted to `/boot/` the following is fine. Otherwise
use path arguments of `bootctl` to adjust the path.

```sh
bootctl install
```

### Create loader config

Content of `/boot/loader/loader.conf`:

```conf
default arch
timeout 2
console-mode max
editor 0
```

### Create boot entries

- For the intel microcode install the `intel-ucode` package.
- "cryptdevice=... root=..." are on the **options** line!
  - `cryptdevice` gets the UUID of the LUKS partition
  - `root` gets the UUID of the root partition in the LUKS container
  - `resume` gets the UUID of the swap partition in the LUKS container
- in vim: `:r ! blkid` pastes the output into vim

```sh
nvim /boot/loader/entries/arch.conf
```

```conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options cryptdevice=UUID=123adf-1234asdf123-1234d-234fdfa:arch
options root=UUID=123-234
options resume=UUID=134-123 rw
```

and create the fallback configuration `arch-fallback.conf`

```conf
title   Arch Linux Fallback
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux-fallback.img
options cryptdevice=UUID=123adf-1234asdf123-1234d-234fdfa:arch
options root=UUID=123-234
options resume=UUID=134-123 rw
```

**Summary:** You should have created 3 files:

- `/boot/loader/entries/arch.conf`
- `/boot/loader/entries/arch-fallback.conf`
- `/boot/loader/loader.conf`

### Exit and Reboot

```sh
exit
umount -R /mnt
reboot
```

**That's it. You installed a fully functional basic archlinux system.
Let's install a graphical environment.**

## Checks after rebooting

If so, you can disable root login (at least, I like to do that)

```sh
sudo -i

# if successful, do
passwd -l root
# or replace the root password hash in /etc/shadow with an '!'
```

### Internet Connection

#### Systemd-networkd

If wlan is used and `iwd` is installed, enable it so that `systemd-networkd`
can use it.
```sh
systemctl enable --now iwd
```

Then create a config file for the network interface (multiple are fine) which
sould be managed by `systemd-networkd`.

In `/etc/systemd/network/net.network`
```
[Match]
Name=wlan0
Name=eth0

[Network]
DHCP=yes
```

Then enable `systemd-networkd`
```sh
systemctl enable --now systemd-networkd
```

For DNS with systemd, activate the following service:
```sh
systemctl enable --now systemd-resolved
```

This is the recommended way to propagate the systemd-resolved managed
configuration to all DNS clients (e.g. `dig` will then work). See [here for
more information](https://wiki.archlinux.org/title/Systemd-resolved#DNS).

```sh
sudo ln -rsf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

Also see [Network](./network.md).

#### DHCPCD

If you installed `dhcpcd`, run `dhcpcd eth0`.

#### Set an IP Address Manually

```sh
# set (a not used) IP
ip addr add 192.168.178.250/24 dev eth0
# set interface up
ip link set eth0 up
# set default gateway
ip route add default via 192.168.178.1 dev eth0

# or for wifi (you must have installed 'dialog wpa_supplicant')
wifi-menu
```

### Install basic services

Enable the `timesyncd` service of systemd (check with `date` command). The
following enables and starts `timesyncd`.

```sh
systemctl enable --now systemd-timesyncd
timedatectl set-ntp true
```

Only install the following packages if you need them. Otherwise, you can
install them later at any time.

```sh
pacman -S acpid avahi cups

# Enable them at boot
systemctl enable acpid avahi-daemon org.cups.cupsd.service
```

## Video Driver

### Intel

Works out of the box. It's **not recommended** to install the following package
but it might be needed in special cases. See
[here](https://wiki.archlinux.org/index.php/Intel_graphics)

```sh
pacman -S xf86-video-intel
```

### Nvidia

```sh
pacman -S nvidia nvidia-settings
```

Take a look the issue with [GDM and Nvidia boot
order](#fixing-boot-order-for-gdm) if you encounter problems.

#### Fixing boot order for `gdm`

_This should not be necessary at all._

I had some issues while using Gnome as desktop: `gdm` would start before the
nvidia modules were ready (or whatever) and therefore fail, meaning I didn't get
the login manager. Then I had to manually restart `gdm` and everything works
but that's annoying.

Add nvidia modules to initramfs to load them first. Also add a pacman hook to
make sure that the initramfs is updated if the `nvidia` package is updated.

See [this
link](https://wiki.archlinux.org/index.php/NVIDIA#DRM_kernel_mode_setting) for
more information.

In `/etc/mkinitcpio.conf` add the modules
```conf
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Add the pacman hook `/etc/pacman.d/hooks/nvidia.hook`
```
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
# the above command avoids multiple runs of mkinitcpio if both - linux and nvidia package - is updated
```

#### Monitors don't wake up after suspend

- [Nvidia
  forums](https://forums.developer.nvidia.com/t/regression-460-series-black-screen-on-boot-nvidia-modeset-error-gpu-failed-to-allocate-display-engine-core-dma-push-buffer/165598)

Seems to be a regession. possible fixes should be:

- turn on CSM legacy in BIOS (actually that did fix it for me)
- start with kernel parameter `nvidia-drm.modeset=1` Also see [Arch
  wiki](https://wiki.archlinux.org/index.php/NVIDIA#DRM_kernel_mode_setting)

I moved the file `/usr/share/X11/xorg.conf.d/10-quirks.conf` to
`/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf` and added the following
option:
```conf
Option "PrimaryGPU" "yes"
```

Also see [Arch
forum](https://bbs.archlinux.org/viewtopic.php?pid=1881083#p1881083) and
[this](https://bbs.archlinux.org/viewtopic.php?pid=1881506#p1881506)


### Open Source Nvidia Driver Nouveau

```sh
pacman -S xf86-video-nouveau
```

### Virtualbox

```sh
# choose the 'modules-arch' version
pacman -S virtualbox-guest-utils
```

## Desktop Environment

### i3

Probably needed packages

```sh
feh [--bg-scale]
xrandr arandr
lxappearance
```
For configuration take a look at
[this](https://gitlab.com/Maaxxs/dotfiles/-/blob/master/.config/i3/config).

### Sway

Install
```sh
pacman -S sway swaylock swayidle alacritty xorg-xwayland wofi
```

For configuration take a look at
[this](https://gitlab.com/Maaxxs/dotfiles/-/blob/master/.config/sway/config).

`sway` can then be started from a tty with the command `sway`.
Autostart in `tty` can be done as follows in the shell initialization file (such
as `~/.zshrc`):

```sh
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec sway
fi
```

Using pipewire and wireplumber for audio.

```sh
pacman -S pipewire pipewire-pulse wireplumber rtkit pavucontrol
```

For bluetooth install `blueman`. If `wireplumber` is used, then the audio is
actually switchted automatically to the new bluetooth device and back.

### XFCE4

#### Installation

Install X, XFCE and LightDM

```sh
pacman -S xorg-server xorg-xinit xfce4 xfce4-goodies lightdm lightdm-gtk-greeter networkmanager network-manager-applet nm-connection-editor

# enable for boot
systemctl enable lightdm NetworkManager
```

For `pulseaudio` and `alsa` install the following:
```sh
pacman -S (alsa-tools) alsa-utils pulseaudio-alsa pulseaudio-bluetooth pavucontrol
```

I use pipewire as a full replacement for pulseaudio and pulseaudio-bluetooth.
Install
```sh
pacman -S pipewire pipewire-pulse pavucontrol (pamixer)
```

The following is required for WebRTC screen sharing `xdg-desktop-portal` and
a backend for it, eg. for `sway`:
```sh
pacman -S xdg-desktop-portal pipewire-media-session xdg-desktop-portal-wlr
# Gnome: xdg-desktop-portal-gtk
```

#### XFCE Logout

I am using `light-locker-command` to lock my sessions.

```sh
pacman -S light-locker-command
```

Go to `/usr/bin/xflock4`
In the for loop add the line "light-locker-command -l"

```sh
for lock_cmd in \
    "light-locker-command -l"\
    "xscreensaver-command -lock" \
    "gnome-screensaver-command --lock"
do
    $lock_cmd >/dev/null 2>&1 && exit
done
```

#### Don't save session on Exit

in "Settings Editor" go to "xfce4-session"
In the `general` tab, create a new property named `SaveOnExit`, Type `BOOL` and set it to False

### GNOME

Install Gnome Display Manager, group `gnome` and `gnome-extra` if desired.

```sh
pacman -S gdm gnome (gnome-extra)
systemctl enable gdm NetworkManager
```

See issue with [`gdm` and Nvidia](#fixing-boot-order-for-gdm)


## Archlinux Tweaks

### Power

```sh
pacman -S upower
```

### OBS Studio

Install `v4l2loopback-dkms` and load the module with
```sh
sudo modprobe v4l2loopback
```
Then it's possible start a virtual camera in OBS. See also
<https://github.com/obsproject/obs-studio/pull/3182>

### XDG home directories

```sh
pacman -S xdg-user-dirs
xdg-user-dirs-update
```

### Syslog-ng

#### Installation

```sh
pacman -S syslog-ng
```

#### Configuration

Change in `/etc/syslog-ng/syslog-ng.conf`

```conf
filter f_everything { level(debug..emerg) and not facility(auth, authpriv); };
```

to

```conf
filter f_everything { level(debug..emerg) and not facility(auth, authpriv) and not filter(f_iptables); };
```

This will stop output of `iptables` to `/var/log/everything.log`

### Gnome Shell Extensions

Worth to take a look at

- Alternate Tab
- NoAnnoyance
- Dash to Dock
- Dash to Panel
- Clipboard Indicator
- No topleft hot corner
- Top Icons Plus
- Removable drive menu
- Caffeine
- Remove dropdown arrows
- Suspend button
- User Themes
- Media player indicator

### Top Icons Plus

is not maintened anymore. GNOME 40 broke the package. Repo was forked and a
patch from
<https://github.com/kofemann/TopIcons-plus/commit/98cd17aa324a031e2ee3d344582dfdafd1e4642f>
applied to get it working with Gnome 40 (not merged upstream). Therefore, the
package `gnome-shell-extension-topicons-plus` still works.


### Keyboard

Set german keyboard layout

```sh
localectl set-x11-keymap de pc105 nodeadkeys
```

Set US as default layout and switch to german layout while pressing the 'Right Alt Key'

```sh
localectl set-x11-keymap us,de ,pc105 ,nodeadkeys grp:switch
```

To switch between us and de layout while holding the CAPSLOCK key use this:
```sh
localectl set-x11-keymap us,de ,pc105 ,nodeadkeys grp:caps_switch
```

You can do that manually as well in `/etc/X11/xorg.conf.d/20-keyboard.conf`

```conf
Section "InputClass"
  Identifier "sytem-keyboard"
  MatchIsKeyboard "on"
  Option "XkbLayout" "us,de"
  Option "XkbModel" ",pc105"
  Option "XkbVariant" ",nodeadkeys"
  Option "XkbOption" "grp:switch"
EndSection
```

### Install AUR Helper

I use `yay`

```sh
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -rsi
cd .. && rm -r yay/
```

### Printer Configuration

```sh
pacman -S system-config-printer cups-pk-helper
```

Everything else can be managed by the GUI Printer Settings

### Themes, Icons, Fonts

Good to install, needed by a lot of packages if using XFCE4: `gtk-engine-murrine`.

#### Official Repo Themes

```sh
noto-fonts
ttf-hack
arc-icon-theme
arc-gtk-theme
breeze
numix-gtk-theme
papirus-icon-theme
faenza-icon-theme
```

#### AUR Themes

```sh
numix-circle-icon-theme-git
numix-frost-themes ????
numix-icon-theme-git
numix-themes-darkblue
sardi-icons
surfn-icons-git
vibrancy-colors
breeze-snow-cursor-theme
numix-circle-icon-theme-git
xfce-theme-greybird
```

### Steam

Activate `[multilib]` Repo in `/etc/pacman.conf`

```sh
pacman -Syy steam
yay -S steam-fonts
```

### Add custom fonts

- Directory: `~/.local/share/fonts`
- eg. put the windows fonts in there.
- Update your font cache with `fc-cache -f`


### Grub Customization

_Only applicable if using `grub`._

In `/etc/default/grub`

```conf
GRUB_CMDLINE_LINUX_DEFAULT=“text“
GRUB_GFXMODE=“1920x1080x32“
GRUB_COLOR_NORMAL=“white/black“
GRUB_COLOR_HIGHLIGHT=“green/black“
GRUB_BACKGROUND=“/usr/share/pixmaps/arch-grub.png“
```

### LightDM GTK Greeter Configuration

Install `lightdm-gtk-greeter-settings` for a configuration GUI.
Manually edits can be done in `/etc/lightdm/lightdm-gtk-greeter.conf`.

```conf
[greeter]
background=/usr/share/pixmaps/nameOfPic.png
position=200,start 480,start
active-monitor=0
clock-format=(CW %U) %a, %d.%m.%Y   %H:%M
```

For the clock format, see [the cheatsheet](https://strftime.org/)

- `%a` - Weekday as locale’s abbreviated name.
- `%d` - Day of the month as a zero-padded decimal number.
- `%m` - Month as a zero-padded decimal number.
- `%Y` - Year with century as a decimal number.
- `%H` - Hour (24-hour clock) as a zero-padded decimal number.
- `%M` - Minute as a zero-padded decimal number.
- `%U` - Week number of the year (Sunday as the first day of the week) as a
  zero padded decimal number. All days in a new year preceding the first Sunday
  are considered to be in week 0.

### SSD Trim

```sh
systemctl enable fstrim.timer
```

### No f\*cking beep

Run the following as root

```sh
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
```

### Firefox

Don't open the menu when pressing the `alt` key. Go to `about:config` and set:
```
ui.key.menuAccessKeyFocuses = false
```

Fix for GTK dark theme [see here](https://wiki.archlinux.org/index.php/Firefox/Tweaks#Unreadable_input_fields_with_dark_GTK_themes)

Change default zoom level:

Go to `about:config`, look for `layout.css.devPixelsPerPx` and change it to
~1.2. The default is -1, which respects the system settings.

### Pacman Commands

If using `zsh` as shell I can absolutely recommend the `archlinux` plugin which
provides lots of aliases. More [information about zsh
plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins).

Get all explicitly installed packages

```sh
pacman -Qeq
```

Get explicitly installed packages of official respository

```sh
pacman -Qneq
```

Get explicitly installed packages of AUR

```sh
pacman -Qmeq
```

Show all Orphans

```sh
pacman -Qtdq
```

### Telegram

Start Telegram minimized in Tray

```sh
telegram-desktop -startintray
```

### Use all cores when compressing

```sh
pacman -S pigz xz
```

change the following in `/etc/makepkg.conf`

```sh
COMPRESSGZ=(pigz -c -f -n)
COMPRESSXZ=(xz -c -z - --threads=0)
```

### Compton Start on all screens

```sh
compton -b -d :0
```

### Redshift Bug with Geoclue

in `/etc/geoclue/geoclue.conf` add at the end

```conf
[redshift]
allowed=true
system=false
users=
```

### Laptop change brightness in smaller steps

```sh
pacman -S light
```

Exampel configuration as keyboard shortcuts

```conf
Alt+. = light -U 5
Alt+, = light -A 5
Alt+Shift+> = light -S 100
Alt+Shift+< = light -S 1
```

### Install Arduino

```sh
pacman -S arduino arduino-avr-core
```

### Install XFCE4 Dev Dependencies

```sh
pacman -S xfce4-dev-tools
```

### Patch the awesome Hack Font

See [Github Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)

```sh
yay -S nerd-fonts-hack
```

### Firefox Customization

#### Good Scrolling with Touchpads

Add this environment variable `env MOZ_USE_XINPUT2=1` to disable the conversion
from touchpad to mousewheel movement.

#### about:config

- `layers.acceleration.force-enabled` -> True. (enable OpenGL based compositing
  which for smooth scrolling)
- `layers.omtp.enabled` -> True further improve performance for scrolling

#### No Titlebar

Main menu -> Customize -> Uncheck 'Title Bar' Box in the bottom left corner.

### Wireshark

Make sure, you install wireshark first and then add youself to the group

```sh
pacman -S wireshark-qt
usermod -aG wireshark username
```

### Powertop

```sh
pacman -S powertop
```

Run with `sudo powertop` and navigate to the **Tunables** Tab.
Set everything to **Good**.

### Mackup

_I'm not using this anymore. Instead I use my own git respository. See
[Dotfiles](https://gitlab.com/maaxxs/dotfiles)._

Sync config files across multiple machines.
[Github Mackup](https://github.com/lra/mackup)

```sh
pip3 install --user mackup
```

Config file could look like this.
See [Configuration](https://github.com/lra/mackup/blob/master/doc/README.md)

```conf
engine = file_system
path = Mega
directory = Mackup

# Add personal files to backup here
[configuration_files]

[applications_to_ignore]
gnupg
```

If you are using the Open Source Build of VS Code, then make sure to link the
config (`.config/Code - OSS`) correctly for Mackup, which is looking for
`.config/Code`.

```sh
cd .config
# if there is a Code folder, remove it (save you config files if you didn't
# port them to the "Code - OSS" foler)

rm -rf ./Code
ln -s "Code - OSS" Code
```

That's it. Now Mackup is looking in "Code - OSS" for the VS Code config files.

### Asciidoc and Asciidoctor

```sh
pacman -S asciidoctor asciidoc

# install the pdf generator
gem install asciidoctor-pdf --pre

# install syntax highlithing support
gem install rouge
```

Add `~/.gem/ruby/2.6.0/bin/` to the `$PATH` variable.

To use rouge as syntax highlighter, set `:source-highlighter: rouge` at the
top of the .adoc document.

### Add OpenVPN configuration file to NetworkManager with nmcli

Import the configuration file

```sh
sudo nmcli connection import type openvpn file saved_config.ovpn
```

If the authentication does not work (eg. password is required, but you want to
save it in the file), edit the associated file in
`/etc/NetworkManager/system-connections/`

```conf
[vpn]
password-flags=0
username=yourVPNusername

[vpn-secrets]
password=yourVPNpassword
```

Restart NetworkManager that the changes take effect.

```sh
sudo systemctl restart NetworkManager
```

If it still does not connect, maybe you've got a cert password?

```conf
[vpn]
cert-pass-flags=0

[vpn-secrets]
cert-pass=yourCERTpassword
```

Again: Restart NetworkManager that the changes take effect.

### Gestures support

```sh
# Add yourself to the input group. Log Out and log in that the change takes effect
sudo gpasswd -a yourUsername input

# install dependencies. xf86-input-libinput should be installed already
pacman -S xdotool wmctrl xf86-input-libinput
```

Visit [Github Libinput Gestures](https://github.com/bulletmark/libinput-gestures) for more infos.

```sh
git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
sudo make install (or sudo ./libinput-gestures-setup install)
```

Standard configuration is in `/etc/libinput-gestures.conf`. Create your
user config in `~/.config/libinput-gestures.conf`. Visit the link above on
how to create a configuration file. It may look like:

```conf
gesture swipe up 3 xdotool key alt+f
gesture swipe down 3 xdotool key ctrl+w
gesture swipe right 3 xdotool key alt+Left
gesture swipe left 3 xdotool key alt+Right
gesture swipe left 4 xdotool key ctrl+super+Right
gesture swipe right 4 xdotool key ctrl+super+Left
gesture swipe down 4 xdotool key ctrl+alt+d
```

After you created your config or changed something, reload it with user
permissions via
```sh
libinput-gestures-setup restart
```

### Pacman Hooks

[Online Archlinux manual about hooks](https://jlk.fjfi.cvut.cz/arch/manpages/man/alpm-hooks.5)

- Default directory for pacman hooks: `/etc/pacman.d/hooks`

Structure of a pacman hook
```conf
[Trigger] (Required, Repeatable)
Operation = Install|Upgrade|Remove (Required, Repeatable)
Type = File|Package (Required)
Target = <Path|PkgName> (Required, Repeatable)

[Action] (Required)
Description = ... (Optional)
When = PreTransaction|PostTransaction (Required)
Exec = <Command> (Required)
Depends = <PkgName> (Optional)
AbortOnFail (Optional, PreTransaction only)
NeedsTargets (Optional)
```

Example with `paccache` (part of the package `pacman-contrib`)

Run `paccache -r` after every install, upgrade and remove process. This checks
`/var/cache/pacman/pkg` and only keeps the last three version of a package.


Save the following to `/etc/pacman.d/hooks/clean_cache.hook`
```conf
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache...
When = PostTransaction
Exec = /usr/bin/paccache -r
Depends = pacman-contrib
```


## Programs

### Signal Messenger

Start with tray icon and show window:
```sh
signal-desktop --use-tray-icon
```

Start minimized in tray
```sh
signal-desktop --start-in-tray
```

### Official Repo Programs

```sh
chromium
firefox firefox-i18n-de
qt4 vlc
libreoffice-fresh libreoffice-fresh-de   hunspell-de
thunderbird thunderbird-i18n-de
catfish
gvfs ntfs-3g gvfs-smb gvfs-mtp gvfs-nfs gvfs-gphoto2 sshfs
openconnect networkmanager-openconnect
wget
git
gparted dosfstools
most
hplip
darktable
geeqie
light-locker
xfce4-xkb-plugin (switch keyboard lang)
lightdm-gtk-greeter-settings
baobab
binwalk
blueman
bluez
bluez-utils
borg
davfs2
evince
gdb
gimp
gitg
glade
gnome-calculator
jupyter
jupyter-nbconvert
lynis
mathjax
most
ncdu
neofetch
p7zip
pdfshuffler
peda
powerline-fonts
pulseaudio-bluetooth
radare2
redshift
reflector
rkhunter
rofi
rsync
stress
testdisk
traceroute
unzip
virtualbox-guest-iso
xarchiver
xcursor-simpleandsoft
youtube-dl
```

### AUR Programs

```sh
trizen
chromium-widevine
conky-nvidia
etcher
grub-customizer
simple-mtpfs
menulibre
shotcut
teamviewer
virtualbox-ext-oracle
vivaldi
woeusb-git
wps-office
wps-office-extension-german-dictionary
dropbox
discord-canary
gmusicbrowser
gtk-theme-config
ida-free
jmtpfs
vim-gruvbox-git
```

### Visual Studio Code (vscode)

#### Autocomplete for GOject (Gtk, Gio, Gdk, ...)

(Python!) [Github Fakegir](https://github.com/strycore/fakegir)
in VS Code Settings:

```json
    "python.autoComplete.extraPaths": [
        "/home/max/.cache/fakegir/"
    ],
```

#### Markdown PDF Extension

Use system chromium path

```json
"markdown-pdf.executablePath": "/usr/bin/chromium",
```


## Hardware info

```sh
sudo hwinfo --short
sudo lshw -short
sudo lscpu
inxi -Fx
```

## Security

### Umask

change umask in `/etc/profile` to

- 077 (very strict, some things might not work anymore)
- 027 (quite fine)
- 022 is Default

### Programs for Security

- rkhunter (run as cronjob?)
- lynis
- arpwatch

### Firewall

Install `ufw`. The default config is deny all incoming and allow outgoing.
Forwarding is disabled. Run the following once after installing.

```sh
ufw enable
```

