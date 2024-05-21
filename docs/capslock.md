---
title: "Capslock - Make it Useful"
---

Goal:

* tap capslock: maps to ESC
* hold capslock: map to CTRL

File: `/etc/interception/udevmon.d/caps2esc.yaml`:

```yaml
# caps2esc -m 1 := map caps to esc/ctrl
- JOB: intercept -g $DEVNODE | caps2esc -m 1 | uinput -d $DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
```

The `-m 0|1|2` meaning:

```txt
    -m mode    0: default
                  - caps as esc/ctrl
                  - esc as caps
               1: minimal
                  - caps as esc/ctrl
               2: useful on 60% layouts
                  - caps as esc/ctrl
                  - esc as grave accent
                  - grave accent as caps
```

Make sure that the `udevmon.service` is running.

