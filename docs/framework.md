# Framework

I've got the Framework 13, 12th Gen Intel i5-1240P.

## Enabling tlp battery charging thresholds.

The following option must be set.
Check the [current documentation for the Framework](https://linrunner.de/tlp/settings/bc-vendors.html#chromebooks-and-framework)
and whether there are any issues.

In `/etc/modprobe.d/cros_charge-control.conf`.

```conf
options cros_charge-control probe_with_fwk_charge_control=1
```

Reload the kernel module `cros_charge-control`.
When running `tlp-stat -b` the output should show the charging thresholds set in `/etc/tlp.conf`.

```
$ sudo tlp-stat -b
[...]
/sys/class/power_supply/BAT1/charge_control_start_threshold =     75 [%]
/sys/class/power_supply/BAT1/charge_control_end_threshold   =     80 [%]
/sys/class/power_supply/BAT1/charge_behaviour               = [auto] inhibit-charge force-discharge
[...]
```
