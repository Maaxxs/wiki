# Archlinux

- [Install Archlinux](#install-archlinux)
  - [Create filesystem](#create-filesystem)
  - [Mount all partitions](#mount-all-partitions)
  - [Install Base system](#install-base-system)
  - [Generate File system Table](#generate-file-system-table)
  - [Enter your system](#enter-your-system)
  - [Set some basic stuff](#set-some-basic-stuff)
  - [Set the Time Zone](#set-the-time-zone)
  - [Add a user](#add-a-user)
  - [Allow members of group wheel to gain root priviliges](#allow-members-of-group-wheel-to-gain-root-priviliges)
  - [Edit and generate the locales](#edit-and-generate-the-locales)
  - [Bootloader](#bootloader)
    - [Grub on BIOS - Legacy systems](#grub-on-bios---legacy-systems)
      - [Install](#install)
      - [Generate Grub configuration](#generate-grub-configuration)
    - [Systemd Boot on UEFI systems](#systemd-boot-on-uefi-systems)
      - [Install](#install-1)
      - [Create boot entries and the loader configuration](#create-boot-entries-and-the-loader-configuration)
  - [Exit and Reboot](#exit-and-reboot)
  - [Check if you sudo into root](#check-if-you-sudo-into-root)
  - [Check internet connection](#check-internet-connection)
  - [Install basic services](#install-basic-services)
  - [Video Driver](#video-driver)
    - [Intel](#intel)
    - [Nvidia](#nvidia)
    - [Open Source Nvidia Driver Nouveau](#open-source-nvidia-driver-nouveau)
    - [Virtualbox](#virtualbox)
  - [Install XFCE4 as Desktop](#install-xfce4-as-desktop)
  - [GNOME](#gnome)
  - [Reboot](#reboot)
- [Archlinux Tweaks](#archlinux-tweaks)
  - [XDG home directories](#xdg-home-directories)
  - [Syslog-ng](#syslog-ng)
    - [Installation](#installation)
    - [Configuration](#configuration)
  - [Gnome Shell Extensions](#gnome-shell-extensions)
  - [i3 as Desktop](#i3-as-desktop)
  - [Keyboard](#keyboard)
  - [Install AUR Helper Trizen](#install-aur-helper-trizen)
  - [Printer Configuration](#printer-configuration)
  - [Themes, Icons, Fonts](#themes-icons-fonts)
    - [Official Repo Themes](#official-repo-themes)
    - [AUR Themes](#aur-themes)
  - [Steam](#steam)
  - [XFCE Logout](#xfce-logout)
  - [Add custom fonts](#add-custom-fonts)
  - [Grub Customization](#grub-customization)
  - [LightDM GTK Greeter Configuration](#lightdm-gtk-greeter-configuration)
  - [SSD Trim](#ssd-trim)
  - [No f\*cking beep](#no-fcking-beep)
  - [Don't save session on Exit](#dont-save-session-on-exit)
  - [FireFox Fix GTK dark Theme](#firefox-fix-gtk-dark-theme)
  - [FireFox Default Zoom Level](#firefox-default-zoom-level)
  - [Pacman Commands](#pacman-commands)
  - [Gitg to English](#gitg-to-english)
  - [Telegram](#telegram)
  - [Use all cores when compressing](#use-all-cores-when-compressing)
  - [Powerline Bash](#powerline-bash)
  - [Compton Start on all screens](#compton-start-on-all-screens)
  - [Grep](#grep)
  - [Redshift Bug with Geoclue](#redshift-bug-with-geoclue)
  - [Laptop change brightness in smaller steps](#laptop-change-brightness-in-smaller-steps)
  - [Install Arduino](#install-arduino)
  - [Install XFCE4 Dev Dependencies](#install-xfce4-dev-dependencies)
  - [Patch the awesome Hack Font](#patch-the-awesome-hack-font)
  - [NeoVim fuzzy search](#neovim-fuzzy-search)
  - [Firefox Customization](#firefox-customization)
    - [Good Scrolling with Touchpads](#good-scrolling-with-touchpads)
    - [about:config](#aboutconfig)
    - [No Titlebar](#no-titlebar)
  - [Wireshark](#wireshark)
  - [Powertop](#powertop)
  - [Mackup](#mackup)
  - [Asciidoc and Asciidoctor](#asciidoc-and-asciidoctor)
  - [Add OpenVPN configuration file to NetworkManager with nmcli](#add-openvpn-configuration-file-to-networkmanager-with-nmcli)
  - [Gestures support](#gestures-support)
- [Programs](#programs)
  - [Official Repo Programs](#official-repo-programs)
  - [AUR Programs](#aur-programs)
- [Visual Studio Code (vscode)](#visual-studio-code-vscode)
  - [Autocomplete for GOject (Gtk, Gio, Gdk, ...)](#autocomplete-for-goject-gtk-gio-gdk)
  - [Markdown PDF Extension](#markdown-pdf-extension)
- [Pacman Hooks](#pacman-hooks)
  - [Auszug aus dem Manual zu alpm Hooks (oben verlinkt)](#auszug-aus-dem-manual-zu-alpm-hooks-oben-verlinkt)
  - [Example](#example)
- [Hardware info](#hardware-info)
- [Security](#security)
  - [Umask](#umask)
  - [Programs for Security](#programs-for-security)
  - [Firewall](#firewall)

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

You can check if you booted in efi mode: if the following command lists some
content then you did.

```sh
ls /sys/firmware/efi
```

Partition of the drive: 
- Create a EFI (ef00) partition of 512MiB size.
  - if you've got a windows installation you can use the Windows EFI partition
      if it's big enough which should usually be the case.
- Create a Linux (can be the LUKS type 8309) parition of the rest.

```sh
gdisk /dev/sda
```

Format efi partition (sda1) and create and open the luks container

```sh
mkfs.fat -F32 /dev/sda1

cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 lvm
``` 

I want hibernation to be available so a swap partition must be created.

```sh
pvcreate /dev/mapper/lvm
vgcreate arch /dev/mapper/lvm
lvcreate -L 8G arch -n swap
lvcreate -l 100%FREE arch -n root
```

### Create filesystems and activate swap

```sh
mkfs.ext4 /dev/arch/root
mkswap /dev/arch/swap
swapon /dev/arch/swap
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
pacstrap /mnt base base-devel linux linux-firmware intel-ucode bash-completion dhcpcd (dialog wpa_supplicant)
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
HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 filesystems resume fsck)
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

_@param -m: create home directory_\
_@param -G: other groups_\
_@param -s: Shell._ Default is `/bin/bash`

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
%wheel ALL = (ALL) ALL
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

```sh
nvim /boot/loader/loader.conf
```

```conf
default arch
timeout 2
console-mode max
editor 0
```

## Create boot entries

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

arch-fallback.conf

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

**That's it. You installed a fully functional basic archlinux system.**\
**Let's install a graphical environment**

### Check if you sudo into root

If so, you can disable root login (at least, I like to do that)

```sh
sudo -i

# if successful, do
passwd -l root
# or replace the root password hash in /etc/shadow with an '!'
```

### Check internet connection

`ping archlinux.org`
If no connection is available run

```sh
ip a
dhcpcd your-ethernet-interface

If `dhcpcd` is not available set an IP address manually:

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

Enable the `timesyncd` service of systemd (check with `date` command)

```sh
systemctl enable systemd-timesyncd
systemctl start systemd-timesyncd
```

If you don't know what they do, use google.

```sh
pacman -S acpid avahi cups

# Enable them at boot
systemctl enable acpid avahi-daemon org.cups.cupsd.service
```

### Video Driver

#### Intel

Works out of the box. The following package is usually not recommended to
install but might be needed in special cases. See
[here](https://wiki.archlinux.org/index.php/Intel_graphics)

```sh
pacman -S xf86-video-intel
```

#### Nvidia

```sh
pacman -S nvidia nvidia-settings
```

#### Fixing boot order for `gdm`

I had some problem when having intalled gnome as desktop that `gdm` would load
before the nvidia modules and therefore fail. Then you have to manually restart
`gdm` and everything works but that's annoying.

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

seems to be a regession. possible fixes should be: 
- turn on CSM legacy in BIOS (actually that did fix it for me)
- start with kernel parameter `nvidia-drm.modeset=1` Also see [Arch
  wiki](https://wiki.archlinux.org/index.php/NVIDIA#DRM_kernel_mode_setting)

I moved the file `/usr/share/X11/xorg.conf.d/10-quirks.conf` to
`/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf` and added the following
option: `Option "PrimaryGPU" "yes"`

Also see [Arch
forum](https://bbs.archlinux.org/viewtopic.php?pid=1881083#p1881083) and
[this](https://bbs.archlinux.org/viewtopic.php?pid=1881506#p1881506)


#### Open Source Nvidia Driver Nouveau

```sh
pacman -S xf86-video-nouveau
```

#### Virtualbox

```sh
# choose the 'modules-arch' version
pacman -S virtualbox-guest-utils
```

### Install XFCE4 as Desktop

Install X, XFCE and LightDM

```sh
pacman -S xorg-server xorg-xinit xfce4 xfce4-goodies lightdm lightdm-gtk-greeter networkmanager network-manager-applet nm-connection-editor

# enable for boot
systemctl enable lightdm NetworkManager

# install some audio stuff
pacman -S (alsa-tools) alsa-utils pulseaudio-alsa pulseaudio-bluetooth pavucontrol
```

### GNOME

Install Gnome Display Manager, group `gnome` and `gnome-extra` if desired.

```sh
pacman -S gdm gnome (gnome-extra)
systemctl enable gdm NetworkManager
```

### Reboot

**Congratulations! You installed a Desktop and a Login Manager**\
**Reboot and you should be able to login into your graphical environment**


## Archlinux Tweaks

### OBS Studio

Install `v4l2loopback-dkms` and load the module with `sudo modprobe
v4l2loopback`. Then it's possible start a virtual camera in OBS. See also
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

### i3 as Desktop

Probably needed packages

```sh
feh [--bg-scale]
compton
xrandr arandr
lxappearance
```

### Keyboard

Set german keyboard layout

```sh
localectl set-x11-keymap de pc105 nodeadkeys
```

Set US as default layout and switch to german layout while pressing the 'Right Alt Key'

```sh
localectl set-x11-keymap us,de ,pc105 ,nodeadkeys grp:switch
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

Good to install, needed by a lot of packages: `gtk-engine-murrine`

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
trizen -S steam-fonts
```

### XFCE Logout

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

### Add custom fonts

Directory: `~/.local/share/fonts`
eg. put the windows fonts in there.
Update your font cache

```sh
fc-cache
```

### Grub Customization

in `/etc/default/grub`

```conf
GRUB_CMDLINE_LINUX_DEFAULT=“text“
GRUB_GFXMODE=“1920x1080x32“
GRUB_COLOR_NORMAL=“white/black“
GRUB_COLOR_HIGHLIGHT=“green/black“
GRUB_BACKGROUND=“/usr/share/pixmaps/arch-grub.png“
```

### LightDM GTK Greeter Configuration

Install `lightdm-gtk-greeter-settings` for a GUI.
Manually edit in `/etc/lightdm/lightdm-gtk-greeter.conf`

```conf
background=/usr/share/pixmaps/nameOfPic.png
position=200,start 480,start
active-monitor=0
```

Set "Date - Time" in Login Screen

```conf
%d %b - %H:%M
```

### SSD Trim

```sh
systemctl enable fstrim.timer
```

### No f\*cking beep

Run the following as root

```sh
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
```

### Don't save session on Exit

in "Settings Editor" go to "xfce4-session"
In the `general` tab, create a new property named `SaveOnExit`, Type `BOOL` and set it to False

### FireFox Fix GTK dark Theme

[See here](https://wiki.archlinux.org/index.php/Firefox/Tweaks#Unreadable_input_fields_with_dark_GTK_themes)

### FireFox Default Zoom Level

Go to `about:config` and look for `layout.css.devPixelsPerPx`.
Change it to ~1.2
Default is -1, which respects system settings

### Pacman Commands

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

### Gitg to English

Hack to switch Gitg to english, if system language is german. Always start Gitg with the following. (eg. change 'exec' it in `/usr/share/applications/gitg.desktop`)

```sh
bash -c "LANG=en_US.UTF8 && gitg"
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

### Grep

Find changed config **files** (if you leave some searchable string in there)

_@param -i: case insensitiv_\
_@param -r: recurse_\
_@param -l: show only filenames_

```sh
egrep "edited by me" -irl
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
trizen -S nerd-fonts-hack
```

### Firefox Customization

#### Good Scrolling with Touchpads

Add this environment variable `env MOZ_USE_XINPUT2=1` to disable the conversion
from touchpad to mousewheel movement.

#### about:config

`layers.acceleration.force-enabled` -> True. (enable OpenGL based compositing which for smooth scrolling)
`layers.omtp.enabled` -> True further improve performance for scrolling

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
permissions via `libinput-gestures-setup restart`

## Programs

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

## Visual Studio Code (vscode)

### Autocomplete for GOject (Gtk, Gio, Gdk, ...)

(Python!) [Github Fakegir](https://github.com/strycore/fakegir)
in VS Code Settings:

```json
    "python.autoComplete.extraPaths": [
        "/home/max/.cache/fakegir/"
    ],
```

### Markdown PDF Extension

Use system chromium path

```json
"markdown-pdf.executablePath": "/usr/bin/chromium",
```

---

## Pacman Hooks

[Online Arch Manual zu Hooks](https://jlk.fjfi.cvut.cz/arch/manpages/man/alpm-hooks.5)

- Standardordner für Pacman: `/usr/share/libalpm/hooks/`
- Weitere Ordner in `/etc/pacman.conf` konfigurierbar. Option `HookDir=`
  - Default ist `/etc/pacman.d/hooks`
- Dateien enden auf `.hook`, zB. `clean_cache.hook`

### Auszug aus dem Manual zu alpm Hooks (oben verlinkt)

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

### Example

Räume nach jedem erfolgreichem Install, Upgrade, Remove Prozess den Pacman Cache in `/var/cache/pacman/pkg` auf.
`paccache` ist Teil des `pacman-contrib` Pakets.
`paccache -r` behält die 3 neusten Versionen eines Paketes und löscht den Rest (`paccache --help`)
Speichere Folgendes in `/etc/pacman.d/hooks/clean_cache.hook`

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

## Hardware info

```sh
sudo hwinfo --short
sudo lshw -short
sudo lscpu
inxi -Fx
```

## Shortcuts

- make `Alt+Tab` switch between windows not applications. In settings->Keyboard
  Shortcuts->*Switch Windows* to shortcut `Alt+Tab`

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
Forwarding is disabled. Run the following.

```sh
ufw enable
```

