# TLP - Power Management

```sh
pacman -S tlp
systemctl enable --now tlp
```

The Arch Linux wiki suggests to mask these services to avoid conflicts (with other services that interact with them, I guess?)

```sh
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket
```

## Framework 13

2026.03.07: I don't have the systemd service running at the moment, though.

For the Framework laptop, definitely take a look at the [`framework_tool`](https://github.com/FrameworkComputer/framework-system).

`/etc/tlp.conf`

```sh
# No pop noise on AC.
SOUND_POWER_SAVE_ON_AC=0
#SOUND_POWER_SAVE_ON_BAT=1

# performance.
CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance
CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power

# Restore charging limits when AC is unplugged.
# Issue `tlp fullcharge` to fully charge the battery. Once AC is unplugged once,
# then the limits in this config file will be restored (otherwise it will
# happen at the next reboot).
RESTORE_THRESHOLDS_ON_BAT=1

# battery charging thresholds
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
```

