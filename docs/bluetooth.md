# Bluetooth

Get bluetooth version supported by the device.

```sh
$ btmgmt info

Index list with 1 item
hci0:   Primary controller
        addr XX:XX:XX:XX:XX:XX version 8 manufacturer ....
```

Check the `version X` field against the [official specifications](https://www.bluetooth.com/specifications/assigned-numbers/).

Copied from specifications, last modified on 2022­09­07.

| Name                                              | Version
| ------------------------------------------------- | -------
| Bluetooth® Core Specification 1.0b (Withdrawn)    | 0x00
| Bluetooth® Core Specification 1.1 (Withdrawn)     | 0x01
| Bluetooth® Core Specification 1.2 (Withdrawn)     | 0x02
| Bluetooth® Core Specification 2.0+EDR (Withdrawn) | 0x03
| Bluetooth® Core Specification 2.1+EDR (Withdrawn) | 0x04
| Bluetooth® Core Specification 3.0+HS (Withdrawn)  | 0x05
| Bluetooth® Core Specification 4.0 (Withdrawn)     | 0x06
| Bluetooth® Core Specification 4.1 (Deprecated)    | 0x07
| Bluetooth® Core Specification 4.2                 | 0x08
| Bluetooth® Core Specification 5.0                 | 0x09
| Bluetooth® Core Specification 5.1                 | 0x0A
| Bluetooth® Core Specification 5.2                 | 0x0B
| Bluetooth® Core Specification 5.3                 | 0x0C
