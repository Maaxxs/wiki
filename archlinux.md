# Archlinux

- [Archlinux](#Archlinux)
  - [Install Archlinux](#Install-Archlinux)
    - [Create filesystem](#Create-filesystem)
    - [Mount all partitions](#Mount-all-partitions)
    - [Install Base system](#Install-Base-system)
    - [Generate File system Table](#Generate-File-system-Table)
    - [Enter your system](#Enter-your-system)
    - [Set some basic stuff](#Set-some-basic-stuff)
    - [Set the Time Zone](#Set-the-Time-Zone)
    - [Add a user](#Add-a-user)
    - [Allow members of group wheel to gain root priviliges](#Allow-members-of-group-wheel-to-gain-root-priviliges)
    - [Edit and generate the locales](#Edit-and-generate-the-locales)
    - [Bootloader](#Bootloader)
      - [Grub on BIOS - Legacy systems](#Grub-on-BIOS---Legacy-systems)
        - [Install](#Install)
        - [Generate Grub configuration](#Generate-Grub-configuration)
      - [Systemd Boot on UEFI systems](#Systemd-Boot-on-UEFI-systems)
        - [Install](#Install-1)
        - [Create boot entries and the loader configuration](#Create-boot-entries-and-the-loader-configuration)
    - [Exit and Reboot](#Exit-and-Reboot)
    - [Check if you sudo into root](#Check-if-you-sudo-into-root)
    - [Check internet connection](#Check-internet-connection)
    - [Install basic services](#Install-basic-services)
    - [Video Driver](#Video-Driver)
      - [Intel](#Intel)
      - [Nvidia](#Nvidia)
      - [Open Source Nvidia Driver Nouveau](#Open-Source-Nvidia-Driver-Nouveau)
      - [Virtualbox](#Virtualbox)
    - [Install XFCE4 as Desktop](#Install-XFCE4-as-Desktop)
    - [GNOME](#GNOME)
    - [Reboot](#Reboot)
  - [Archlinux Tweaks](#Archlinux-Tweaks)
    - [Syslog-ng](#Syslog-ng)
      - [Installation](#Installation)
      - [Configuration](#Configuration)
    - [Gnome Shell Extensions](#Gnome-Shell-Extensions)
    - [i3 as Desktop](#i3-as-Desktop)
    - [Keyboard](#Keyboard)
    - [Install AUR Helper Trizen](#Install-AUR-Helper-Trizen)
    - [Printer Configuration](#Printer-Configuration)
    - [Themes, Icons, Fonts](#Themes-Icons-Fonts)
      - [Official Repo Themes](#Official-Repo-Themes)
      - [AUR Themes](#AUR-Themes)
    - [Steam](#Steam)
    - [XFCE Logout](#XFCE-Logout)
    - [Add custom fonts](#Add-custom-fonts)
    - [Grub Customization](#Grub-Customization)
    - [LightDM GTK Greeter Configuration](#LightDM-GTK-Greeter-Configuration)
    - [SSD Trim](#SSD-Trim)
    - [No f*cking beep](#No-fcking-beep)
    - [Don't save session on Exit](#Dont-save-session-on-Exit)
    - [FireFox Fix GTK dark Theme](#FireFox-Fix-GTK-dark-Theme)
    - [FireFox Default Zoom Level](#FireFox-Default-Zoom-Level)
    - [Pacman Commands](#Pacman-Commands)
    - [Gitg to English](#Gitg-to-English)
    - [Telegram](#Telegram)
    - [Use all cores when compressing](#Use-all-cores-when-compressing)
    - [Powerline Bash](#Powerline-Bash)
    - [Compton Start on all screens](#Compton-Start-on-all-screens)
    - [Grep](#Grep)
    - [Redshift Bug with Geoclue](#Redshift-Bug-with-Geoclue)
    - [Laptop change brightness in smaller steps](#Laptop-change-brightness-in-smaller-steps)
    - [Install Arduino](#Install-Arduino)
    - [Install XFCE4 Dev Dependencies](#Install-XFCE4-Dev-Dependencies)
    - [Patch the awesome Hack Font](#Patch-the-awesome-Hack-Font)
    - [NeoVim fuzzy search](#NeoVim-fuzzy-search)
    - [Firefox Customization](#Firefox-Customization)
      - [Good Scrolling with Touchpads](#Good-Scrolling-with-Touchpads)
      - [about:config](#aboutconfig)
      - [No Titlebar](#No-Titlebar)
    - [Wireshark](#Wireshark)
    - [Powertop](#Powertop)
    - [Mackup](#Mackup)
    - [Asciidoc and Asciidoctor](#Asciidoc-and-Asciidoctor)
    - [Add OpenVPN configuration file to NetworkManager with nmcli](#Add-OpenVPN-configuration-file-to-NetworkManager-with-nmcli)
    - [Gestures support](#Gestures-support)
  - [Programs](#Programs)
    - [Official Repo Programs](#Official-Repo-Programs)
    - [AUR Programs](#AUR-Programs)
  - [Visual Studio Code (vscode)](#Visual-Studio-Code-vscode)
    - [Autocomplete for GOject (Gtk, Gio, Gdk, ...)](#Autocomplete-for-GOject-Gtk-Gio-Gdk)
    - [Markdown PDF Extension](#Markdown-PDF-Extension)
  - [Pacman Hooks](#Pacman-Hooks)
    - [Auszug aus dem Manual zu alpm Hooks (oben verlinkt)](#Auszug-aus-dem-Manual-zu-alpm-Hooks-oben-verlinkt)
    - [Example](#Example)
  - [Hardware info](#Hardware-info)
  - [Security](#Security)
    - [Umask](#Umask)
    - [Programs for Security](#Programs-for-Security)
    - [Firewall](#Firewall)

## Install Archlinux

You might want to override your harddrive, especially if you want to encrypt it.

``` sh
# Parameter -n: how many times?
shred –verbose –random-source=/dev/urandom -n1 /dev/sdX
```

For a german keyboard layout

``` sh
loadkeys de
```

Partition your drive. Assumend drive throughout is `/dev/sda`

``` sh
fdisk /dev/sda
```

- BIOS – Legacy – DOS  
  - o -> dos table  
  - n -> p -> 1 -> first sector -> +50GB  
  - p [print] -> t [type ändern evtl]  
  - w [write]  
- UEFI – GPT  
  - g -> gpt table  
  - EFI [type: ef00] Partition mit +512M  
  - … je nachdem / und /home
  - mkfs.fat -F 32 -n EFIBOOT /dev/sda1

If you want Hibernation

- Create Swap Partition
- Add hook `resume` in mkinitcpio.conf (after udev hook!)
- specify resume Kernel-Parameter in Boot Loader Config Files

### Create filesystem

``` sh
mkfs.ext4 -L ROOT /dev/sdaX
mkswap -L SWAP /dev/sdaX
```

### Mount all partitions

``` sh
mount /dev/sdaX /mnt          # root
mount /dev/sdaX /mnt/home     # home
swapon /dev/sdaX              # activate Swap

# check mountpoints
df -Th

# check swap
free -h
```

### Install Base system

``` sh
# Add dialog and wpa_supplicant if you need wifi.
pacstrap /mnt base base-devel bash-completion intel-ucode (dialog wpa_supplicant)
```

### Generate File system Table

``` sh
genfstab -Up /mnt >> /mnt/etc/fstab

# check with: cat /mnt/etc/fstab
```

### Enter your system

``` sh
arch-chroot /mnt
```

### Set some basic stuff

- `/etc/hostname`

    ``` sh
    # Hostname
    hostname
    ```

- `/etc/locale.conf`

    ``` sh
    # german
    LANG=de_DE.UTF-8
    LANGUAGE=de_DE

    # english
    LANG=en_US.UTF-8
    LANGUAGE=en_US
    ```

- `/etc/vconsole.conf`

    ``` sh
    # german layout
    KEYMAP=de-latin1-nodeadkeys

    # us layout
    KEYMAP=us

    # Font on early boot
    FONT=lat9w-16
    ```

### Set the Time Zone

``` sh
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```

### Add a user

*@param -m: create home directory*\
*@param -g: main user group*\
*@param -G: other groups*\
*@param -s: Shell*

``` sh
useradd -m -g users -G wheel,audio,video -s /bin/bash username

# Set password for your user
passwd username

# Set password for root
passwd
```

### Allow members of group wheel to gain root priviliges

``` sh
EDITOR=nano visudo

# remove the '#' in the line: 
%wheel ALL = (ALL) ALL
```

### Edit and generate the locales

``` sh
# eg: remove '#' in front of all 'de_DE' or 'en_US' entries
vim /etc/locale.gen

# generate
locale-gen
```

### Bootloader

#### Grub on BIOS - Legacy systems

##### Install

``` sh
# Install Grub and os-prober to detect other installed operating systems if you have any
pacman -S grub os-prober
grub-install /dev/sda
```

##### Generate Grub configuration

``` sh
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Systemd Boot on UEFI systems

##### Install

``` sh
pacman -S efibootmgr dosfstools gptfdisk

# install to disk
bootctl install
```

##### Create boot entries and the loader configuration

Append the parameter `quiet` if you don't want to see systemd startup messages on boot

The options line:

``` conf
options   root=LABEL=label-of-root resume=LABEL=label-of-swap rw
options   root=UUID=uuid-of-root resume=UUID=uuid-of-swap rw
```

Create the following configuration files

- `/boot/loader/entries/arch.conf`

    ``` conf
    title    Arch Linux
    linux    /vmlinuz-linux
    initrd   /intel-ucode.img
    initrd   /initramfs-linux.img
    options  root=LABEL=p_arch resume=LABEL=p_swap rw
    ```

The fallback configuration file

- `/boot/loader/configuration/arch-fallback.conf`

    ``` conf
    title    Arch Linux Fallback
    linux    /vmlinuz-linux
    initrd   /intel-ucode.img
    initrd   /initramfs-linux-fallback.img
    options  root=LABEL=p_arch resume=LABEL=p_swap rw
    ```

- Bootloader configuration `/boot/loader/loader.conf`

``` conf
default arch
timeout 3
editor  0
console-mode max
```

**Summary:** You should have created 3 files:  
`/boot/loader/entries/arch.conf`  
`/boot/loader/entries/arch-fallback.conf`  
`/boot/loader/loader.conf`  

### Exit and Reboot

``` sh
exit
umount -R /mnt
reboot
```

**That's it. You installed a fully functional basic archlinux system.**\
**Let's install a graphical environment**

### Check if you sudo into root

If so, you can disable root login

``` sh
sudo -i

# if successful, do

passwd -l root
# or replace the root password hash in /etc/shadow with an '!'
```

### Check internet connection

`ping archlinux.org`  
If no connection is available run

``` sh
ip a
dhcpcd your-ethernet-interface

# or for wifi (you must have installed 'dialog wpa_supplicant')
wifi-menu
```

### Install basic services

If you don't know what they do, use google.

``` sh
pacman -S acpid ntp avahi cronie cups

# Enable them at boot
systemctl enable acpid avahi-daemon cronie ntpd org.cups.cupsd.service

# synchronize
sudo ntpd -gq
# check
date

# Set the time in the hardware clock
hwclock -w
```

### Video Driver

#### Intel

``` sh
pacman -S xf86-video-intel
```

#### Nvidia

``` sh
pacman -S nvidia nvidia-settings
```

#### Open Source Nvidia Driver Nouveau

``` sh
pacman -S xf86-video-nouveau
```

#### Virtualbox

``` sh
# choose the 'modules-arch' version
pacman -S virtualbox-guest-utils
```

### Install XFCE4 as Desktop

Install X, XFCE and LightDM

``` sh
pacman -S xorg-server xorg-xinit xfce4 xfce4-goodies lightdm lightdm-gtk-greeter networkmanager network-manager-applet nm-connection-editor

# enable for boot
systemctl enable lightdm NetworkManager

# install some audio stuff
pacman -S alsa-tools alsa-utils pulseaudio-alsa pavucontrol
```

### GNOME

Install Gnome Display Manager, group `gnome` and `gnome-extra` if desired.

``` sh
pacman -S gdm gnome (gnome-extra)
systemctl enable gmd

# Maybe as well?
pacman -S xorg-server xorg-xinit xorg-server-xwayland
```


### Reboot

**Congratulations! You installed a Desktop and a Login Manager**\
**Reboot and you should be able to login into your graphical environment**

## Archlinux Tweaks

### Syslog-ng

#### Installation

``` sh
pacman -S syslog-ng
```

#### Configuration

Change in `/etc/syslog-ng/syslog-ng.conf`

``` conf
filter f_everything { level(debug..emerg) and not facility(auth, authpriv); };
```

to

``` conf
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

``` sh
feh [--bg-scale]
compton
xrandr arandr
lxappearance
```

### Keyboard

Set german keyboard layout

``` sh
localectl set-x11-keymap de pc105 nodeadkeys
```

Set US as default layout and switch to german layout while pressing the 'Right Alt Key'

``` sh
localectl set-x11-keymap us,de ,pc105 ,nodeadkeys grp:switch
```

You can do that manually as well in `/etc/X11/xorg.conf.d/20-keyboard.conf`

``` conf
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

``` sh
git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg -rsi
cd .. && rm -rf trizen/
```

### Printer Configuration

``` sh
pacman -S system-config-printer cups-pk-helper
```

Everything else can be managed by the GUI Printer Settings

### Themes, Icons, Fonts

Good to install, needed by a lot of packages: `gtk-engine-murrine`

#### Official Repo Themes

``` sh
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

``` sh
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

``` sh
pacman -Syy steam
trizen -S steam-fonts
```

### XFCE Logout

I am using `light-locker-command` to lock my sessions.

``` sh
pacman -S light-locker-command
```

Go to `/usr/bin/xflock4`  
In the for loop add the line "light-locker-command -l"

``` sh
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

``` sh
fc-cache
```

### Grub Customization

in `/etc/default/grub`

``` conf
GRUB_CMDLINE_LINUX_DEFAULT=“text“
GRUB_GFXMODE=“1920x1080x32“
GRUB_COLOR_NORMAL=“white/black“
GRUB_COLOR_HIGHLIGHT=“green/black“
GRUB_BACKGROUND=“/usr/share/pixmaps/arch-grub.png“
```

### LightDM GTK Greeter Configuration

Install `lightdm-gtk-greeter-settings` for a GUI.  
Manually edit in `/etc/lightdm/lightdm-gtk-greeter.conf`

``` conf
background=/usr/share/pixmaps/nameOfPic.png
position=200,start 480,start
active-monitor=0
```

Set "Date - Time" in Login Screen

``` conf
%d %b - %H:%M
```

### SSD Trim

``` sh
systemctl enable fstrim.timer
```

### No f*cking beep

**Run as Root**

``` sh
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

Get all explicitly installed packages

``` sh
pacman -Qeq
```

Get explicitly installed packages of official respository

``` sh
pacman -Qneq
```

Get explicitly installed packages of AUR

``` sh
pacman -Qmeq
```

Show all Orphans

``` sh
pacman -Qtdq
```

### Gitg to English

Hack to switch Gitg to english, if system language is german. Always start Gitg with the following. (eg. change 'exec' it in `/usr/share/applications/gitg.desktop`)

``` sh
bash -c "LANG=en_US.UTF8 && gitg"
```

### Telegram

Start Telegram minimized in Tray

``` sh
telegram-desktop -startintray
```

### Use all cores when compressing

``` sh
pacman -S pigz xz
```

change the following in `/etc/makepkg.conf`

``` sh
COMPRESSGZ=(pigz -c -f -n)
COMPRESSXZ=(xz -c -z - --threads=0)
```

### Powerline Bash

[Github Powerline Shell](https://github.com/b-ryan/powerline-shell)

### Compton Start on all screens

``` sh
compton -b -d :0
```

### Grep

Find changed config **files** (if you leave some searchable string in there)

*@param -i: case insensitiv*\
*@param -r: recurse*\
*@param -l: show only filenames*

``` sh
egrep "edited by me" -irl
```

### Redshift Bug with Geoclue

in `/etc/geoclue/geoclue.conf` add at the end

``` conf
[redshift]
allowed=true
system=false
users=
```

### Laptop change brightness in smaller steps

``` sh
trizen -S light

```

Exampel configuration as keyboard shortcuts

``` conf
Alt+. = light -U 5
Alt+, = light -A 5
Alt+Shift+> = light -S 100
Alt+Shift+< = light -S 1
```

### Install Arduino

``` sh
pacman -S arduino arduino-avr-core
```

### Install XFCE4 Dev Dependencies

``` sh
pacman -S xfce4-dev-tools
```

### Patch the awesome Hack Font

See [Github Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)

``` sh
trizen -S nerd-fonts-hack
```

### NeoVim fuzzy search

Use [fzf](https://github.com/junegunn/fzf)
To use `:Ag` install

``` sh
pacman -S the_silver_searcher
```

Coresponding part in `init.vim`

``` sh
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

Make sure, you install wireshark first and then add youself to the group

``` sh
pacman -S wireshark-qt
useradd -aG wireshark username
```

### Powertop

``` sh
pacman -S powertop
```

Run with `sudo powertop` and navigate to the **Tunables** Tab.
Set everything to **Good**.

### Mackup

Sync config files across multiple machines.
[Github Mackup](https://github.com/lra/mackup)

``` sh
pip3 install --user mackup
```

Config file could look like this. 
See [Configuration](https://github.com/lra/mackup/blob/master/doc/README.md)

``` conf
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

``` sh
cd .config
# if there is a Code folder, remove it (save you config files if you didn't
# port them to the "Code - OSS" foler)

rm -rf ./Code
ln -s "Code - OSS" Code
```

That's it. Now Mackup is looking in "Code - OSS" for the VS Code config files.

### Asciidoc and Asciidoctor

``` sh
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

``` sh
sudo nmcli connection import type openvpn file saved_config.ovpn
```

If the authentication does not work (eg. password is required, but you want to 
save it in the file), edit the associated file in
`/etc/NetworkManager/system-connections/`

``` conf
[vpn]
password-flags=0
username=yourVPNusername

[vpn-secrets]
password=yourVPNpassword
```

Restart NetworkManager that the changes take effect.

``` sh
sudo systemctl restart NetworkManager
```

If it still does not connect, maybe you've got a cert password?

``` conf
[vpn]
cert-pass-flags=0

[vpn-secrets]
cert-pass=yourCERTpassword
```

Again: Restart NetworkManager that the changes take effect.

### Gestures support

``` sh
# Add yourself to the input group. Log Out and log in that the change takes effect
sudo gpasswd -a yourUsername input

# install dependencies. xf86-input-libinput should be installed already
pacman -S xdotool wmctrl xf86-input-libinput
```

Visit [Github Libinput Gestures](https://github.com/bulletmark/libinput-gestures) for more infos.

``` sh
git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
sudo make install (or sudo ./libinput-gestures-setup install)
```

Standard configuration is in `/etc/libinput-gestures.conf`. Create your 
user config in `~/.config/libinput-gestures.conf`. Visit the link above on 
how to create a configuration file. It may look like:

``` conf
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

``` sh
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

``` sh
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

``` json
    "python.autoComplete.extraPaths": [
        "/home/max/.cache/fakegir/"
    ],
```

### Markdown PDF Extension

Use system chromium path

``` json
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

``` conf
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

``` conf
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

``` sh
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

TODO: Get some configuration here.

- nftables
- iptables
