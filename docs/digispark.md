# Digispark

## Arduino IDE

Install the arduino IDE and the `libusb-compat` package.
```bash
pacman -S arduino arduino-avr-core
pacman -S libusb-compat
```

Add the driver with the following URL in Arduino (File -> Preferences ->
Additional Board Manager URLs).
```
https://raw.githubusercontent.com/digistump/arduino-boards-index/master/package_digistump_index.json
```


## Add `udev` rules

`/etc/udev/rules.d/49-micronucleus.rules`
```
# UDEV Rules for Micronucleus boards including the Digispark.
#
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
#
# If you share your linux system with other users, or just don't like the
# idea of write permission for everybody, you can replace MODE:="0666" with
# OWNER:="yourusername" to create the device owned by you, or with
# GROUP:="somegroupname" and mange access using standard unix groups.
```

## Troubleshooting page

[See here](http://digistump.com/wiki/digispark/tutorials/linuxtroubleshooting) 
with this [general tutorial](http://digistump.com/wiki/digispark).

