# Archlinux

- [Install Archlinux](#install-archlinux)
  - [Create filesystem](#create-filesystem)
  - [Mount all partitions](#mount-all-partitions)
  - [Install Base system](#install-base-system)
  - [Generate File system Table](#generate-file-system-table)
  - [Enter your system](#enter-your-system)
  - [Set some basic stuff](#set-some-basic-stuff)
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
  - [Check internet connection](#check-internet-connection)
  - [Install basic services](#install-basic-services)
  - [Video Driver](#video-driver)
    - [Intel](#intel)
    - [Nvidia](#nvidia)
    - [Open Source Nvidia Driver Nouveau](#open-source-nvidia-driver-nouveau)
    - [Virtualbox](#virtualbox)
  - [Install XFCE4 as Desktop](#install-xfce4-as-desktop)
  - [Reboot](#reboot)
- [Archlinux Tweaks](#archlinux-tweaks)
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
  - [No f*cking beep](#no-fcking-beep)
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
- [Programs](#programs)
  - [Official Repo Programs](#official-repo-programs)
  - [AUR Programs](#aur-programs)
- [Visual Studio Code (vscode)](#visual-studio-code-vscode)
  - [Autocomplete for GOject (Gtk, Gio, Gdk, ...)](#autocomplete-for-goject-gtk-gio-gdk)
  - [Markdown PDF Extension](#markdown-pdf-extension)
- [Pacman Hooks](#pacman-hooks)
  - [Auszug aus dem Manual zu alpm Hooks (oben verlinkt)](#auszug-aus-dem-manual-zu-alpm-hooks-oben-verlinkt)
  - [Example](#example)
- [Security](#security)
  - [Umask](#umask)
  - [Programs for Security](#programs-for-security)
  - [Firewall](#firewall)

## Install Archlinux

You might want to override your harddrive, especially if you want to encrypt it.

```
# Parameter -n: how many times?
shred –verbose –random-source=/dev/urandom -n1 /dev/sdX
```

For a german keyboard layout

```
loadkeys de
```

Partition your drive. Assumend drive throughout is `/dev/sda`

```
fdisk /dev/sda
```

[TODO]: Refactor-that-stuff

- BIOS – Legacy – DOS  
o --> dos table  
n --> p --> 1 --> first sector --> +50GB  
p [print] --> t [type ändern evtl]  
w [write]  
- UEFI – GPT  
g → gpt table  
1. EFI [type: ef00] Partition mit +512M  
… je nachdem / und /home
mkfs.fat -F 32 -n EFIBOOT /dev/sda1


If you want Hibernation

- Create Swap Partition
- Add hook `resume` in mkinitcpio.conf (after udev hook!)
- specify resume Kernel-Parameter in Boot Loader Config Files

### Create filesystem

```
@param -L: Label
@X: partition number

mkfs.ext4 -L ROOT /dev/sdaX
mkswap -L SWAP /dev/sdaX
```

### Mount all partitions

```
mount /dev/sdaX /mnt          # root
mount /dev/sdaX /mnt/home     # home
swapon /dev/sdaX              # activate Swap

# check mountpoints
df -Th

# check swap
free -h
```

### Install Base system

```
# Add dialog and wpa_supplicant if you need wifi.
pacstrap /mnt base base-devel bash-completion intel-ucode (dialog wpa_supplicant)
```

### Generate File system Table

```
genfstab -Up /mnt >> /mnt/etc/fstab

# check with: cat /mnt/etc/fstab
```

### Enter your system

```
arch-chroot /mnt
```

### Set some basic stuff

```
# Hostname
echo arch > /etc/hostname

# german
echo LANG=de_DE.UTF-8 > /etc/locale.conf
echo LANGUAGE=de_DE >> /etc/locale.conf

# english
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo LANGUAGE=en_US >> /etc/locale.conf


# german layout
echo KEYMAP=de-latin1-nodeadkeys > /etc/vconsole.conf

# us layout
echo KEYMAP=us > /etc/vconsole.conf

# Font on early boot
echo FONT=lat9w-16 >> /etc/vconsole.conf

# Time Zone
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```

### Add a user

```
@param -m: create home directory
@param -g: main user group
@param -G: other groups
@param -s: Shell
useradd -m -g users -G wheel,audio,video -s /bin/bash username

# Set password for your user
passwd username

# Set password for root
passwd
```

### Allow members of group wheel to gain root priviliges

```
EDITOR=nano visudo

# remove the '#' in the line: 
%wheel ALL = (ALL) ALL
```

### Edit and generate the locales

```
# eg: remove '#' in front of all 'de_DE' or 'en_US' entries
nano /etc/locale.gen

# generate
locale-gen
```

### Bootloader

#### Grub on BIOS - Legacy systems

##### Install

```
# Install Grub and os-prober to detect other installed operating systems if you have any
pacman -S grub os-prober
grub-install /dev/sda
```

##### Generate Grub configuration

```
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Systemd Boot on UEFI systems

##### Install

```
pacman -S efibootmgr dosfstools gptfdisk

# install to disk
bootctl install
```

##### Create boot entries and the loader configuration

The options line:
```
options   root=LABEL=label-of-root resume=LABEL=label-of-swap rw
options   root=UUID=uuid-of-root resume=UUID=uuid-of-swap rw

Append the parameter 'quiet' if you don't want to see systemd startup messages on boot
```

Only use **one** option line!  

In `/boot/loader/entries/` create following configuration files  
Name: `arch.conf`

```
title    Arch Linux
linux    /vmlinuz-linux
initrd   /intel-ucode.img
initrd   /initramfs-linux.img
options  root=LABEL=p_arch resume=LABEL=p_swap rw
```

And the Fallback configuration file  
Name: `arch-fallback.conf`

```
title    Arch Linux Fallback
linux    /vmlinuz-linux
initrd   /intel-ucode.img
initrd   /initramfs-linux-fallback.img
options  root=LABEL=p_arch resume=LABEL=p_swap rw
```

Now choose the default configuration.  
File: `/boot/loader/loader.conf`

```
default arch
timeout 3
editor  0
```

**Summary:** You should have created 3 files:  
`/boot/loader/entries/arch.conf`  
`/boot/loader/entries/arch-fallback.conf`  
`/boot/loader/loader.conf`  

### Exit and Reboot

```
exit
umount -R /mnt
reboot
```

**That's it. You installed a fully functional basic archlinux system.**  
**Let's install a graphical environment**

### Check internet connection

` ping archlinux.org `  
If no connection is available run

```
ip a
dhcpcd your-ethernet-interface

# or for wifi (you must have installed 'dialog wpa_supplicant')
wifi-menu
```

### Install basic services

If you don't know what they do, use google.

```
pacman -S acpid ntp avahi cronie cups

# Enable them at boot
systemctl enable acpid avahi-daemon cronie ntpd org.cups.cupsd.service

# synchronize
sudo ntpg -gq
# check
date
```

### Video Driver

#### Intel

```
pacman -S xf86-video-intel
```

#### Nvidia

```
pacman -S nvidia nvidia-settings
```

#### Open Source Nvidia Driver Nouveau

```
pacman -S xf86-video-nouveau
```

#### Virtualbox

```
# choose the 'modules-arch' version
pacman -S virtualbox-guest-utils
```

### Install XFCE4 as Desktop

Install X, XFCE and LightDM

``` 
pacman -S xorg-server xorg-xinit xfce4 xfce4-goodies lightdm lightdm-gtk-greeter networkmanager network-manager-applet nm-connection-editor

# enable for boot
systemctl enable lightdm NetworkManager

# install some audio stuff
pacman -S alsa-tools alsa-utils pulseaudio-alsa pavucontrol
```

### Reboot

**Congratulations! You installed a Desktop and a Login Manager**  
**Reboot and you should be able to login into your graphical environment**

## Archlinux Tweaks

### i3 as Desktop

Probably needed packages

```
feh [--bg-scale]
compton
xrandr arandr
lxappearance 
```

### Keyboard

Set german keyboard layout

```
localectl set-x11-keymap de pc105 nodeadkeys
```

Set US as default layout and switch to german layout while pressing the 'Right Alt Key'

```
localectl set-x11-keymap us,de ,pc105 ,nodeadkeys grp:switch
```

You can do that manually as well in `/etc/X11/xorg.conf.d/20-keyboard.conf`

```
Section "InputClass"
  Identifier "sytem-keyboard"
  MatchIsKeyboard "on"
  Option "XkbLayout" "us,de"
  Option "XkbModel" ",pc105"
  Option "XkbVariant" ",nodeadkeys"
  Option "XkbOption" "grp:switch"
EndSection
```

### Install AUR Helper Trizen

Trizen will be updated by itself/pacman.

```
git clone https://aur.archlinux.org/trizen.git
cd trizen 
makepkg -rsi
cd .. && rm -rf trizen/
```

### Printer Configuration

```
pacman -S system-config-printer cups-pk-helper
```

Everything else can be managed by the GUI Printer Settings


### Themes, Icons, Fonts

Good to install, needed by a lot of packages: `gtk-engine-murrine`

#### Official Repo Themes

```
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

```
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

```
pacman -Syy steam
trizen -S steam-fonts
```

### XFCE Logout 

I am using `light-locker-command` to lock my sessions.

```
pacman -S light-locker-command
```
Go to `/usr/bin/xflock4`  
In the for loop add the line "light-locker-command -l"

```
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

```
fc-cache
```
### Grub Customization

in `/etc/default/grub`

```
GRUB_CMDLINE_LINUX_DEFAULT=“text“
GRUB_GFXMODE=“1920x1080x32“
GRUB_COLOR_NORMAL=“white/black“
GRUB_COLOR_HIGHLIGHT=“green/black“
GRUB_BACKGROUND=“/usr/share/pixmaps/arch-grub.png“
```

### LightDM GTK Greeter Configuration

Install `lightdm-gtk-greeter-settings` for a GUI.  
Manually edit in `/etc/lightdm/lightdm-gtk-greeter.conf`

```
background=/usr/share/pixmaps/nameOfPic.png
position=200,start 480,start
active-monitor=0
```

Set "Date - Time" in Login Screen

```
%d %b - %H:%M
```

### SSD Trim

```
systemctl enable fstrim.timer
```

### No f*cking beep

**Run as Root**

```
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
```

### Don't save session on Exit

in "Settings Editor" go to "xfce4-session"  
In the `general` tab, create a new property named `SaveOnExit`, Type `BOOL` and set it to False

### FireFox Fix GTK dark Theme

**Might be already fixed** TODO  
[See here](https://wiki.archlinux.org/index.php/Firefox/Tweaks#Unreadable_input_fields_with_dark_GTK.2B_themes)

### FireFox Default Zoom Level

Go to `about:config` and look for `layout.css.devPixelsPerPx`.  
Change it to ~1.2  
Default is -1, which respects system settings

### Pacman Commands

Get explicitly installed packages of official respository

```
pacman -Qne | awk '{print $1}'
```

Get explicitly installed packages of AUR

```
pacman -Qme | awk '{print $1}'
```

### Gitg to English

Hack to switch Gitg to english, if system language is german. Always start Gitg with the following. (eg. change 'exec' it in `/usr/share/applications/gitg.desktop`)

```
bash -c "LANG=en_US.UTF8 && gitg"
```
### Telegram

Start Telegram minimized in Tray

```
telegram-desktop -startintray
```

### Use all cores when compressing

```
pacman -S pigz xz
```

change the following in `/etc/makepkg.conf`

```
COMPRESSGZ=(pigz -c -f -n)
COMPRESSXZ=(xz -c -z - --threads=0)
```

### Powerline Bash

[Github Powerline Shell](https://github.com/b-ryan/powerline-shell)

### Compton Start on all screens

```
compton -b -d :0
```

### Grep

Find changed config **files** (if you leave some searchable string in there)

```
@param -i: case insensitiv
@param -r: recurse
@param -l: show only filenames

egrep "edited by me" -irl
```

### Redshift Bug with Geoclue

in `/etc/geoclue/geoclue.conf` add at the end

```
[redshift]
allowed=true
system=false
users=
```

### Laptop change brightness in smaller steps

```
trizen -S light

```

Exampel configuration as keyboard shortcuts

```
Alt+. = light -U 5
Alt+, = light -A 5
Alt+Shift+> = light -S 100
Alt+Shift+< = light -S 1
```

### Install Arduino

```
pacman -S arduino arduino-avr-core
```

### Install XFCE4 Dev Dependencies

```
pacman -S xfce4-dev-tools
```

### Patch the awesome Hack Font

See [Github Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)

```
trizen -S nerd-fonts-hack
```

### NeoVim fuzzy search

Use [fzf](https://github.com/junegunn/fzf)
To use `:Ag` install

```
pacman -S the_silver_searcher
```

Coresponding part in `init.vim`

```
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
```

### Firefox Customization

#### Good Scrolling with Touchpads

Add this environment variable `env MOZ_USE_XINPUT2=1` to disable the conversion
from touchpad to mousewheel movement.  

#### about:config

`layers.acceleration.force-enabled` -> True. (enable OpenGL based compositing which for smooth scrolling)  
`layers.omtp.enabled` -> True  further improve performance for scrolling

#### No Titlebar

Main menu -> Customize -> Uncheck 'Title Bar' Box in the bottom left corner.

### Wireshark

```
pacman -S wireshark-qt
# this file must be executable by root and users in the group wireshark
sudo chmod root:wireshark /usr/bin/dumpcap
useradd -aG wireshark username
```

## Programs

### Official Repo Programs

```
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

```
trizen
chromium-widevine
conky-nvidia
etcher
grub-customizer
simple-mtpfs
menulibre
neofetch
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

```
    "python.autoComplete.extraPaths": [
        "/home/max/.cache/fakegir/"
    ],
```

### Markdown PDF Extension

Use system chromium path

```
"markdown-pdf.executablePath": "/usr/bin/chromium",
```






## Pacman Hooks

[Online Arch Manual zu Hooks](https://jlk.fjfi.cvut.cz/arch/manpages/man/alpm-hooks.5)

- Standardordner für Pacman: `/usr/share/libalpm/hooks/`  
- Weitere Ordner in `/etc/pacman.conf` konfigurierbar. Option `HookDir=` 
  - Default ist `/etc/pacman.d/hooks`  
- Dateien enden auf `.hook`, zB. `clean_cache.hook`

### Auszug aus dem Manual zu alpm Hooks (oben verlinkt)

```
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

```
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

TODO: Get some configuration here.

- nftables
- iptables


