# NixOS

## Show Patches contained in a NixOS Build

Example: OpenSSH

First create the `.drv` file by passing the path to the current OpenSSH
version to `nix-store --deriver`. Then use it to show the patches.

```
$ nix-store -q --deriver /nix/store/ik1hrivpiw5lkmarlzmpk8armfgpxwcf-openssh-9.7p1
$ nix-store -q --binding patches /nix/store/9n6abwsahsgzp4kwhv9z2jqq5lzfsfyn-openssh-9.7p1.drv | tr ' ' '\n' | cat
/nix/store/isik6ifcjxpw22sfh3kz37galficc78c-locale_archive.patch
/nix/store/6id7rg81nbkx9r9pxvax7nssr11xdaas-gss-serv.c.patch?id=a7509603971ce2f3282486a43bb773b1b522af83
/nix/store/ybb4xs45dkngdf3x1xnxqgzn5zmv5alf-dont_create_privsep_path.patch
/nix/store/7jbzj9s2wkbznn93ga3aqka6vfx06gjg-ssh-keysign-8.5.patch
/nix/store/19h9868xxidcxz9jal6rzchn1kf6ayb1-openssh-9.6_p1-CVE-2024-6387.patch
/nix/store/bzcv443j20xn17fm8vgwgcf9rasbbnzn-openssh-9.6_p1-chaff-logic.patch
```

## Installing NixOS with UTM on MacOS

Download the [AArch64](https://nixos.wiki/wiki/NixOS_on_ARM/UEFI) image. More
ARM specific information can be found at the same page.


[Official installation
instructions](https://nixos.org/manual/nixos/stable/index.html#sec-installation)

After creating the VM in UTM and plugging the ISO in as boot image, NixOS can
be installed.


### Installation

Execute as `root`.
```sh
sudo -i
```

Create partitions.
```sh
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart primary 512MiB -1GiB
parted /dev/vda -- mkpart primary linux-swap -1GiB 100%
parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/vda -- set 3 esp on
```

Format the partitions.
```sh
mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2
mkfs.fat -F 32 -n boot /dev/vda3
```

Mount partitions and activate swap.
```sh
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/vda2
```

Generate initial configuration file.
```sh
nixos-generate-config --root /mnt
```

Configuration file in `/mnt/etc/nixos/configuration.nix`.
```conf
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # only enable DHCP for interface enp0s8
  networking.useDHCP = false;
  networking.interfaces.enp0s8.useDHCP = true;

  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  # };
  users.users.mk = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # add "docker" for docker.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];
  environment.systemPackages = with pkgs; [
    git
    neovim
    htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

# settings of the blog guide dude
#   services.vscode-server.enable = true;
#   virtualisation.docker.enable = true;
#   services.openvpn.servers = {
#     vpn = {
#       config = "config /home/user/client.ovpn";
#       authUserPass = {
#         username = "REDACTED";
#         password = "REDACTED";
#       };
#       autoStart = false;
#     };
#   };
}
```

Then install it:
```sh
nixos-install
```

## After configuration changes:

Build and switch and change boot default.
```sh
nixos-rebuild switch
```

Do changes and switch currenlty running system but don't change boot default:
```sh
nixos-rebuild test
```

Only build:
```sh
nixos-rebuild build
```

Set profile name (shows up in boot menu)
```sh
nixos-rebuild switch -p test-name
```

## Upgrade NixOS

Check the [documentation to upgrade NixOS](https://nixos.org/manual/nixos/stable/index.html#sec-upgrading).

```sh
nixos-rebuild switch --upgrade
```

Switch channels with `nix-channel`. Show current channel with

```sh
nix-channel --list
```

Note that channel are set per user. So, you probably want to run this as `root`.

[Garbage
collection](https://nixos.org/manual/nix/stable/introduction.html#garbage-collection):
Delete all packages, which are not in use.
```sh
nix-collect-garbage
```

## Locating Binaries in Packages

```sh
nix-shell -p nix-index
# create the index
nix-index
# search for a binary
nix-locate --top-level mkfs.fat
```

## Generating a Password with `mkpasswd`

The generated hashed password can be put into the file used with
`passwordFile = ./passwd-user.enc`.

```sh
nix-shell -p mkpasswd
mkpasswd -m sha-512
```
