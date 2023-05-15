# Windows

## Backups with Vorta

[Vorta](https://vorta.borgbase.com/) is a frontend for [borg
backup](https://www.borgbackup.org/). Also take a look at the [officical
instructions to install Vorta for
Windows](https://vorta.borgbase.com/install/windows/).

Windows is not yet officially supported by Borg Backup. However, you can
make it work with WSL on Windows.


Necessary steps

- install [VcXsrv](https://sourceforge.net/projects/vcxsrv/) (X server
  for Windows) and run it. You can save the configuration to a file and move it to
  the autostart folder (find it with `Win+r`: `shell:startup`).
- activate WSL in Windows features
- install Ubuntu
- install vorta: `sudo apt install vorta`
- fix errors
  - `ImportError: libQt5Core.so.5 : cannot open shared object file: No
    such file or directory`: run the following

```sh
sudo strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
```

- export environment variables and run vorta
```sh
export DISPLAY=:0
export LIBGL_ALWAYS_INDIRECT=1
export LANG=de_DE.UTF-8
export LANGUAGE=de_DE
vorta
```


Create a Windows shortcut:

- Right click and "new shortcut"
- Put the following in the "Target" field:

```sh
C:\Windows\System32\wsl.exe --distribution Ubuntu bash -c "export DISPLAY=:0 && export LIBGL_ALWAYS_INDIRECT=1 && export LANG=de_DE.UTF-8 && export LANGUAGE=de_DE && vorta"
```

- optionally, check the box to start the program minimized. This will
  start the cmd window minimized while vorta itself will come up
  normally.

All drives should be mounted in WSL at `/mnt/{c,d,...}`.


## Create a bigger ESP partition (default 100MB)

[Source](https://superuser.com/questions/1308324/create-efi-partition-before-installing-windows-10)

1. Boot Windows installer
2. Press `Shift+F10` to open command line
3. Type `diskpart`
4. Type `list disk`. All disks will be printed. Note the number of your disk (most likely `0`. Select it with `select disk 0`
5. Create ESP: `create partition efi size=512` (512MiB)
6. Exit diskpart: `exit`
7. Continue installation


## Telemetry

Switch off the following services.

```
WerSvc — Windows-Fehlerberichterstattungsdienst
DiagTrack — Benutzererfahrungen und Telemetrie im verbundenen Modus
```

### Boot directly into BIOS

```
shutdown /r /fw /f /t 0
```

### Retrive Windows key from firmware table

The bottom couple of rows produced by the following command are your key.

```sh
hexdump -C /sys/firmware/acpi/tables/MSDM
```

