Terminal
==========

Test terminal features

<https://michenriksen.com/posts/italic-text-in-alacritty-tmux-neovim/>

```sh
echo -e '\e[1mBold\e[22m'
echo -e '\e[2mDimmed\e[22m'
echo -e '\e[3mItalic\e[23m'
echo -e '\e[4mUnderlined\e[24m'
echo -e '\e[4:3mCurly Underlined\e[4:0m'
echo -e '\e[4:3m\e[58;2;240;143;104mColored Curly Underlined\e[59m\e[4:0m'
```

# Terminals and Command's Buffering Behaviour

Why some pipes "get stuck" sometimes.
Julia Evans wrote about this in
[Why pipes sometimes get "stuck": buffering](https://jvns.ca/blog/2024/11/29/why-pipes-get-stuck-buffering/).

For example:

```sh
tail -f /some/log/file | grep thing1 | grep thing2
```

Tools like `grep` use an internal buffer, e.g. `BUFSIZE` (8KB) by glibc if the output _is not written to a terminal_.
Hence, the first grep would buffer 8KB before writing to the second grep that would write immediately to the terminal (checked via `isatty` function).

The buffer behavior can be turned off:

* `grep --line-buffered`
* `sed -u`
* `awk`'s `fflush()` function
* `tcpdump -l`
* `jq -u`
* `tr -u`
* cut. apparently there's no way

So to achieve the same result as the initial command with two `grep`s,
we can do:

```sh
tail -f /some/log/file | grep --line-buffered thing1 | grep thing2
tail -f /some/log/file |  awk '/thing1/ && /thing2/'
```

Turn off libc's buffering via LD_PRELOAD and `stdbuf` ([how stdbuf works](https://hmarr.com/blog/how-stdbuf-works/)):

```sh
tail -f /some/log/file | stdbuf -o0 grep thing1 | grep thing2
```

Use `unbuffer` that forces the program's output to be a TTY.
Note that this may have side effects like commands assuming that their output is an actual terminal
and hence behave that way, e.g. grep coloring its output and printing terminal escape sequences.
So that behaviour should be turned off, too.

```sh
tail -f /some/log/file | unbuffer grep thing1 | grep thing2
```

