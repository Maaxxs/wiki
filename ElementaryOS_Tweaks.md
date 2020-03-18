# Elementary OS Tweaks

## Install wing panel

See [here](https://www.linuxuprising.com/2018/08/how-to-re-enable-ayatana-appindicators.html)

1. Copy desktop file, add Pantheon desktop, so indicators are visisble in Pantheon desktop

   ```sh
   mkdir -p ~/.config/autostart

   cp /etc/xdg/autostart/indicator-application.desktop ~/.config/autostart/

   sed -i 's/^OnlyShowIn.*/OnlyShowIn=Unity;GNOME;Pantheon;/' ~/.config/autostart/indicator-application.desktop
   ```

2. Downlad the `wingpanel-indicator-ayatana` deb package and install it

   ```sh
   wget http://ppa.launchpad.net/elementary-os/stable/ubuntu/pool/main/w/wingpanel-indicator-ayatana/wingpanel-indicator-ayatana_2.0.3+r27+pkg17~ubuntu0.4.1.1_amd64.deb

   sudo dpkg -i wingpanel-indicator-ayatana_2.0.3+r27+pkg17~ubuntu0.4.1.1_amd64.deb
   ```

## Reduce space between winpangel indicators

See [here](https://elementaryos.stackexchange.com/questions/17531/how-do-i-decrease-the-gap-between-icons-in-the-status-tray)

Steps:

```sh
sudo vim /usr/share/themes/elementary/gtk-3.0/apps.css
```

1. Look for

   ```css
   composited-indicator {
       padding: 0 6px;
   }

   .composited-indicator > revealer label,
   .composited-indicator > revealer image,
   .composited-indicator > revealer spinner {
   ```

2. Change the line `padding: 0 6px;` to `padding: 0 2px;`
3. Save and log out. Done
