

## Removing local calendars

delete local personal and birthday calendar

in .config/evolution/sources

remove the birthdays.source  system-calendar.source

nope. does not work.


remove managed thing in chrome
sudo dnf remove fedora-chromium-config

## Install rpm fusion free and non-free repos

sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

GPG keys here: https://rpmfusion.org/keys


## install fira code

fira-code-fonts

## Dash to dock

gnome-shell-extension-dash-to-dock

Log out and back in to activate it in the Gnome extension app

## install vs code

Import public key of microsoft

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

Add `vscode.repo` in `/etc/yum.repos.d/` 

sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

Then update and install vs code

sudo dnf check-update
sudo dnf install code

## Install nextcloud client and the nautilus integration

sudo dnf install nextcloud-client nextcloud-client-nautilus 



