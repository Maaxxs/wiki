# GTK

## Themes

Install a theme.
```sh
pacman -S arc-icon-theme arc-solid-gtk-theme
```

List installed GTK themes.
```sh
find $(find ~/.themes /usr/share/themes/ -wholename "*/gtk-3.0" | sed -e "s/^\(.*\)\/gtk-3.0$/\1/") -wholename "*/gtk-2.0" | sed -e "s/.*\/\(.*\)\/gtk-2.0/\1"/
```

Set a theme. Name of GTK theme is the folder name under `/usr/share/themes/`
and for the icon theme under `/usr/share/icons/`.

```sh
gsettings set org.gnome.desktop.interface icon-theme Arc
gsettings set org.gnome.desktop.interface gtk-theme Arc-Dark-solid
```

## Thunar FileChooser Dialog

When opening the file chooser dialog (e.g. save a file), then sort directories first:

```sh
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
```
