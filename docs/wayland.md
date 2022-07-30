# Wayland

Check for [wayland supporting apps here](https://arewewaylandyet.com/).

## Firefox

For good touchpad scrolling, set these in `about:config`.

```conf
mousewheel.min_line_scroll_amount = 150
mousewheel.default.delta_multiplier_x = 30
mousewheel.default.delta_multiplier_y = 30
mousewheel.default.delta_multiplier_z = 30
```

## Chromium

Use wayland backend by creating the file `~/.config/chromium-flags.conf` with
the following content:
```
--enable-features=UseOzonePlatform
--ozone-platform=wayland
```

## Wireshark

Wireshark on sway does not show the menu and the context menu (right click).
A temporary fix is to run Wireshark with `QT_QPA_PLATFORM=xcb` set.

```sh
QT_QPA_PLATFORM=xcb wireshark
```

## Electron

Tell Electron apps to use wayland backend. Create
`~/.config/electron-flags.conf` with the following content:
```
--enable-features=UseOzonePlatform
--ozone-platform=wayland
```

