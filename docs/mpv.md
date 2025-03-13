# MPV

Easily cut videos with [this mpv Lua extension](https://github.com/familyfriendlymikey/mpv-cut).

Installation:

```sh
git clone -b release --single-branch "https://github.com/familyfriendlymikey/mpv-cut.git" ~/.config/mpv/scripts/mpv-cut
```

Start the video with `mpv`.

* Press `c` to begin a cut.
* Seek to a later time in the video.
* Press `c` again to make the cut.
* To cancel a cut, press `C`.

It saves a copy of the video in the same directory as the original file.

For other options, see the [usage](https://github.com/familyfriendlymikey/mpv-cut#usage).

## Play DVDs

To play DVDs with encrypted content, install `libdvdcss` (Arch Linux).

Then insert the DVD and run the next command and it should just work.

```sh
mpv dvd://
```

## Use Hardware Video Decoding

Relevant part in the [man page](https://man.archlinux.org/man/mpv.1#hwdec=_api1,api2,..._no_auto_auto)

`~/.config/mpv/mpv.conf`

```conf
hwdec=auto-safe
```

When hardware decoding is used, it shows up when loading the video file.
You can test while playing a video by pressing `CTRL-h` to toggle between the mode `auto-safe` and `no`.

